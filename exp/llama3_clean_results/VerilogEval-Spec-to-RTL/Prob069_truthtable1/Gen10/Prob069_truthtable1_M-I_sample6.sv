module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Attempting to use a slightly different logic expression
// that could potentially be more efficient in certain technologies
assign f = (x3? x1 : x2);

endmodule