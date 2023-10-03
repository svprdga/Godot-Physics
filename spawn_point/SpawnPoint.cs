using Godot;
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Reflection;

public partial class SpawnPoint : Node3D
{
  private const float TIMER_INTERVAL = 0.01f;
  private const float SCALE = 2.0f;

  [Signal]
  public delegate void InstantiateCubeEventHandler();

  private double elapsedTime = 0d;
  private List<Rid> cubes = new();
  private List<Rid> meshes = new();
  private List<Rid> shapes = new();
  private List<Rid> boxMeshes = new();
  private List<Rid> materials = new();

  public override void _Ready()
  {
    SetProcess(false);
  }

  public override void _PhysicsProcess(double delta)
  {
    for (int i = 0; i < cubes.Count; i++)
    {
      Transform3D transform = (Transform3D)PhysicsServer3D.BodyGetState((Rid)cubes[i], PhysicsServer3D.BodyState.Transform);
      RenderingServer.InstanceSetTransform((Rid)meshes[i], transform);
    }
  }

  public override void _Process(double delta)
  {
    elapsedTime += delta;
    if (elapsedTime >= TIMER_INTERVAL)
    {
      elapsedTime = 0f;
      InstantiateCube();
    }
  }

  public void OnWorldStartTest()
  {
    SetProcess(true);
  }

  private void InstantiateCube()
  {
    EmitSignal(SignalName.InstantiateCube);

    // Create cube
    var cube = PhysicsServer3D.BodyCreate();
    cubes.Add(cube);
    PhysicsServer3D.BodySetMode(cube, PhysicsServer3D.BodyMode.Rigid);

    // Add cube to space
    var space = GetWorld3D().Space;
    PhysicsServer3D.BodySetSpace(cube, space);

    // Add shape
    // shape.Extents = new Vector3(1.0f, 1.0f, 1.0f);
    var shape = PhysicsServer3D.BoxShapeCreate();
    shapes.Add(shape);
    PhysicsServer3D.BodyAddShape(cube, shape);
    PhysicsServer3D.BodySetShapeTransform(cube, 0, new Transform3D(Basis.Identity, Vector3.Zero));

    // Set transform
    var transform = new Transform3D(RandomRotation(), new Vector3(0f, 70f, 0f));
    PhysicsServer3D.BodySetState(cube, PhysicsServer3D.BodyState.Transform, transform);

    // Add mesh
    // boxMesh.Size = new Vector3(SCALE, SCALE, SCALE);
    var boxMesh = PhysicsServer3D.BoxShapeCreate();
    var mesh = RenderingServer.InstanceCreate2(boxMesh, GetWorld3D().Scenario);
    meshes.Add(mesh);
    RenderingServer.InstanceSetTransform(mesh, transform);

    // Set random color
    // var cubeMaterial = new StandardMaterial3D();
    // materials.Add(cubeMaterial);
    // cubeMaterial.AlbedoColor = new Color(GD.Randf(), GD.Randf(), GD.Randf(), 1.0f);

    // Add the material to the cube
    // RenderingServer.InstanceSetSurfaceOverrideMaterial(mesh, 0, cubeMaterial);
  }

  private Basis RandomRotation()
  {
    var axis = new Vector3(GD.Randf(), GD.Randf(), GD.Randf()).Normalized();
    var angle = GD.Randf() * 2 * Mathf.Pi;
    return new Basis().Rotated(axis, angle);
  }
}