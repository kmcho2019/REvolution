module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and1_out;
wire and2_out;

// Continuous assignments for AND gates
assign and1_out = a & b;
assign and2_out = c & d;

// Continuous assignment for OR gate
assign out = and1_out | and2_out;

// NOT gate primitive for out_n, driven by out
not not_gate (out_n, out);

endmodule