within Modelica.Electrical.Machines.Thermal.SynchronousMachines;
model ThermalAmbientSMR
  "Thermal ambient for synchronous machine with reluctance rotor"
  parameter Boolean useDamperCage(start=true)
    "Enable / disable damper cage" annotation (Evaluate=true);
  extends
    Machines.Interfaces.InductionMachines.PartialThermalAmbientInductionMachines(
      redeclare final Machines.Interfaces.InductionMachines.ThermalPortSMR
      thermalPort(final useDamperCage=useDamperCage));
  parameter Modelica.SIunits.Temperature Tr(start=TDefault)
    "Temperature of damper cage (optional)" annotation (Dialog(enable=(
          not useTemperatureInputs and useDamperCage)));
  output Modelica.SIunits.HeatFlowRate Q_flowRotorWinding=
      temperatureRotorWinding.port.Q_flow
    "Heat flow rate of damper cage (optional))";
  output Modelica.SIunits.HeatFlowRate Q_flowTotal=Q_flowStatorWinding +
      Q_flowRotorWinding + Q_flowStatorCore + Q_flowRotorCore +
      Q_flowStrayLoad + Q_flowFriction;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    temperatureRotorWinding annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,30})));
  Modelica.Blocks.Interfaces.RealInput TRotorWinding(unit="K") if (
    useTemperatureInputs and useDamperCage)
    "Temperature of damper cage (optional)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,-120})));
  Modelica.Blocks.Sources.Constant constTr(final k=if useDamperCage then
        Tr else TDefault) if (not useTemperatureInputs or not
    useDamperCage) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-10})));
equation
  connect(constTr.y, temperatureRotorWinding.T) annotation (Line(
      points={{-20,1},{-20,18}}, color={0,0,127}));
  connect(temperatureRotorWinding.port, thermalPort.heatPortRotorWinding)
    annotation (Line(
      points={{-20,40},{-20,100},{0,100}}, color={191,0,0}));
  connect(TRotorWinding, temperatureRotorWinding.T) annotation (Line(
      points={{100,-120},{100,10},{-20,10},{-20,18}}, color={0,0,127}));
  annotation (Icon(graphics={Text(
          extent={{-100,-20},{100,-80}},
          textString="SMR")}), Documentation(info="<html>
Thermal ambient for synchronous machines with reluctance rotor to prescribe winding temperatures either constant or via signal connectors.
Additionally, all losses = heat flows are recorded.
</html>"));
end ThermalAmbientSMR;
