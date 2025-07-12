module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// The existing expression is maintained as it directly implements the required logic.
// For optimization, we could consider if any specific gate structures in the target technology
// could be utilized to reduce area or power consumption. However, without specific details
// on the technology library, we proceed with the current expression.
assign out = a | (~a & ~b & c);

endmodule