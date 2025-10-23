module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Intermediate wire holding concatenation of bytes swapped from input
    wire [15:0] reordered_bytes;

    // Concatenate lower and upper bytes swapped order
    assign reordered_bytes = {in[7:0], in[15:8]};

    // Assign outputs from reordered intermediate wire by slicing
    assign out_hi = reordered_bytes[15:8];  // originally in[7:0]
    assign out_lo = reordered_bytes[7:0];   // originally in[15:8]

endmodule