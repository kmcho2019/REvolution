module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The simplified solution maintains the same logic as the original, 
// focusing on clarity and efficiency.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule