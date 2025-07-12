module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

wire and_out1;
wire and_out2;

// Use the same logic but with a slight reorganization to potentially reduce switching activity
assign and_out1 = a & b;
assign and_out2 = c & d;
assign out = and_out1 | and_out2;
// Since 'out_n' is just the inverted version of 'out', we keep this assignment as is
assign out_n = ~out;

endmodule