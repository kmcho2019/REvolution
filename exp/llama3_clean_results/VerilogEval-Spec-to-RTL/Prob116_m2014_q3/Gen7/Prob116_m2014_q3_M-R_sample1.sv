module TopModule(
    input [3:0] x,
    output f
);

// Intermediate wires to represent key conditions
wire cond1; // x[3] is high and either x[2] or x[1] is high
wire cond2; // x[3] is low and both x[2] and x[1] are high

// Define cond1
assign cond1 = x[3] & (x[2] | x[1]);

// Define cond2, considering synthesizability and logic clarity
assign cond2 = ~x[3] & x[1] & x[2];

// Combine conditions to produce the final output f
assign f = cond1 | cond2;

endmodule