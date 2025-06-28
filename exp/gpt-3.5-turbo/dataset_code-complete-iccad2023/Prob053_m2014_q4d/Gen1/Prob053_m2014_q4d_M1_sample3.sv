module TopModule (
    input clk,
    input in,
    output logic out
);

logic d_ff;

XOR2 xor_gate(.a(in), .b(out), .out(d_ff));

always_ff @(posedge clk)
    d_ff <= d_ff;

assign out = d_ff;

endmodule

module XOR2 (
    input a,
    input b,
    output logic out
);
assign out = a ^ b;
endmodule