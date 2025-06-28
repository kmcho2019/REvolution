module DFlipFlop (
    input clk, reset,
    input d,
    output reg q
);
always @(posedge clk) begin
    if (!reset)
        q <= 1'b0;
    else
        q <= d;
end
endmodule

module XorGate (
    input a, b,
    output xor_out
);
assign xor_out = a ^ b;
endmodule

module TopModule (
    input clk,
    input in,
    output logic out
);
reg d_ff;
wire xor_output;

DFlipFlop d_ff_inst (
    .clk(clk),
    .reset(1'b0),
    .d(xor_output),
    .q(out)
);

XorGate xor_inst (
    .a(in),
    .b(out),
    .xor_out(xor_output)
);
endmodule