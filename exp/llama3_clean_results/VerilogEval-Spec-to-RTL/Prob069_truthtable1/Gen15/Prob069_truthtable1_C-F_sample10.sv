module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintain the direct logical expression for simplicity and optimize through synthesis directives
assign f = (x2 & ~x3) | (x1 & x3);

// Example synthesis directive to optimize for area and power (note: actual directives may vary depending on the synthesis tool)
// attribute syn_keep : boolean;
// attribute syn_preserve : boolean;
// attribute syn_noprune : boolean;

endmodule