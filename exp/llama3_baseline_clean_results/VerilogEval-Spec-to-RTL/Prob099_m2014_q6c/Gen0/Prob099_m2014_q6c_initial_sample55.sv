module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Expressions for next-state signals Y1 and Y3 based on one-hot encoding
assign Y1 = (y[0] && w) || (y[3] && w); // Y1 is high in next state if current state is A and w=1, or current state is D and w=1
assign Y3 = (y[1] && ~w) || (y[5] && w); // Y3 is high in next state if current state is B and w=0, or current state is F and w=1

endmodule