module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintaining the efficient implementation and exploring potential simplifications.
assign f = (~x3 & x2) | (x3 & x1);

endmodule