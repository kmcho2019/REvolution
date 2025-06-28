module DFF (
    input clk,
    input d,
    output reg q
);
always @(posedge clk)
    q <= d;
endmodule

module XOR2 (
    input a, b,
    output c
);
assign c = a ^ b;
endmodule

module TopModule (
    input clk, in,
    output out
);

reg d_ff;
wire xor_out;

DFF dff_inst (
    .clk(clk),
    .d(xor_out),
    .q(d_ff)
);

XOR2 xor_inst (
    .a(in),
    .b(d_ff),
    .c(xor_out)
);

assign out = d_ff;

endmodule