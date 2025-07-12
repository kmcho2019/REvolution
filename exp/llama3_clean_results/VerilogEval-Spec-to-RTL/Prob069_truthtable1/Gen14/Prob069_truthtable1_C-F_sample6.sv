module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintaining the direct and simple implementation of the logical expression
// for optimal area usage and performance, while considering potential
// technology-specific optimizations.
assign f = (x2 && ~x3) || (x1 && x3);

// To potentially leverage technology-specific optimizations, the expression
// could be re-expressed, though the current form is already quite direct.
// Alternative expressions should be considered with the understanding of the
// target technology's optimizations and cell libraries.

endmodule