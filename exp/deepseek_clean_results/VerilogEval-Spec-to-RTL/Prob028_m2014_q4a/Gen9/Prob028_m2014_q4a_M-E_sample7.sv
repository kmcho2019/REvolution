module TopModule (
    input d,
    input ena,
    output q
);

wire and1_out, and2_out, q_bar;

assign and1_out = d & ena;
assign and2_out = q & ~ena;
assign q = and1_out | and2_out;

endmodule