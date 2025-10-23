module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already quite optimized for area and power.
// To potentially improve PPA metrics further, we maintain the same logic
// but consider synthesis constraints for optimal implementation.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule