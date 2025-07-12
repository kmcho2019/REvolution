module TopModule(
    input logic x3,
    input logic x2,
    input logic x1,
    output logic f
);

// The Boolean expression derived from analyzing the truth table
assign f = (x2 & ~x3) | (x1 & x3);

endmodule