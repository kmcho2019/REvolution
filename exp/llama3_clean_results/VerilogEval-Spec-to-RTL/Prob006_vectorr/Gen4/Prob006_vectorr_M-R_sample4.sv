module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7];
// Refactored version for readability and conciseness:
// assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
assign out = {>>{in}};  // Utilizing bit reverse operator (not supported in all tools, so commented out for compatibility)

// To maintain compatibility across different tools, the following approach is used:
assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}; // Direct bit reversal

endmodule