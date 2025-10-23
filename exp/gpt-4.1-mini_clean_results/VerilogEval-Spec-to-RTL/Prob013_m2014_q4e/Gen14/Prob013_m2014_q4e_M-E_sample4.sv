module NANDGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = ~(a & b);
endmodule

module Inverter (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    wire not_in1, not_in2;

    // Invert inputs
    Inverter inv1 (.a(in1), .y(not_in1));
    Inverter inv2 (.a(in2), .y(not_in2));

    // NAND the inverted inputs to get NOR
    NANDGate nand1 (.a(not_in1), .b(not_in2), .y(out));
endmodule