module TopModule (
    input x3,
    input x2,
    input x1,
    output reg f
);

// Intermediate signals to improve readability
wire x2_not_x3 = x2 && !x3;
wire x1_and_x3 = x1 && x3;
wire x2_and_x1 = x2 && x1;

// Combine intermediate signals to produce the final output
assign f = x2_not_x3 || x1_and_x3 || x2_and_x1;

endmodule