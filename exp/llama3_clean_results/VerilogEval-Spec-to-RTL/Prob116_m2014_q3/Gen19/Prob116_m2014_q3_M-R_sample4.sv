module TopModule(
    input [3:0] x,
    output logic f
);

logic x3_high, x3_low;
logic x1_or_x2, x1_and_x2;

assign x3_high = x[3];
assign x3_low = ~x[3];
assign x1_or_x2 = x[1] | x[2];
assign x1_and_x2 = x[1] & x[2];

assign f = (x3_high & x1_or_x2) | (x3_low & x1_and_x2);

endmodule