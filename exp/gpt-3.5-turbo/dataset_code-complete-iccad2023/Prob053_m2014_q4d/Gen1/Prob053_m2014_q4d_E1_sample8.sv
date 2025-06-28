module DFlipFlop (
    input clk, 
    input d, 
    output reg q
);
    always @(posedge clk)
        q <= d;
endmodule

module XORGate (
    input a, 
    input b, 
    output reg c
);
    assign c = a ^ b;
endmodule

module TopModule (
    input clk,
    input in,
    output logic out
);

    logic xor_output;
    logic d_ff_input;
    logic d_ff_output;

    XORGate xor_gate (
        .a(in),
        .b(d_ff_output),
        .c(xor_output)
    );

    DFlipFlop d_flipflop (
        .clk(clk),
        .d(xor_output),
        .q(d_ff_output)
    );

    assign out = d_ff_output;

endmodule