module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implement the simplified logic expression obtained from the K-map
assign f = (~x3 & x2) | (x3 & x1);

endmodule