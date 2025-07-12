module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already quite simple and efficient.
// We maintain the same logical expression but ensure it's synthesized efficiently.
assign f = (~x3 & x2) | (x3 & x1);

endmodule