module TopModule (
    input d,
    input ena,
    output q
);

wire d_and_ena;
wire q_and_not_ena;

assign d_and_ena = d & ena;
assign q_and_not_ena = q & (~ena);
assign q = d_and_ena | q_and_not_ena;

endmodule