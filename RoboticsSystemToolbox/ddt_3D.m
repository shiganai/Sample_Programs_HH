function dotq_input = ddt_3D(t,q_input, Global_Origin, ExternalForce_Origin_Name, wrench)

HomeConfig = homeConfiguration(Global_Origin);
VariableNum = size(HomeConfig,2);

q = q_input(1:VariableNum);
qdot = q_input(1+VariableNum:VariableNum*2);

fext = externalForce(Global_Origin, ExternalForce_Origin_Name, wrench, q);
qddot = forwardDynamics(Global_Origin, q', qdot', [], fext);

dotq_input = [qdot; qddot'];
end