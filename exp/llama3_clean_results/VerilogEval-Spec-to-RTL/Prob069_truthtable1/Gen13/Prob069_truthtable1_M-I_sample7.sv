module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already quite optimized.
// We focus on ensuring the logic is correctly represented for synthesis.
assign f = (~x3 & x2) | (x3 & x1);

endmodule