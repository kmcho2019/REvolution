interface ANDGateInterface(input logic a, input logic b, output logic out_assign, output logic out_alwaysblock);
    modport and_gate(
        input  a,
        input  b,
        output out_assign,
        output out_alwaysblock
    );
endinterface

module ANDGate(
    ANDGateInterface.and_gate and_if
);

assign and_if.out_assign = and_if.a & and_if.b;

always_comb begin
    and_if.out_alwaysblock = and_if.a & and_if.b;
end

endmodule

module TopModule(
    input  logic a,
    input  logic b,
    output logic out_assign,
    output logic out_alwaysblock
);

ANDGateInterface and_if(a, b, out_assign, out_alwaysblock);
ANDGate u_and_gate(.and_if(and_if));

endmodule