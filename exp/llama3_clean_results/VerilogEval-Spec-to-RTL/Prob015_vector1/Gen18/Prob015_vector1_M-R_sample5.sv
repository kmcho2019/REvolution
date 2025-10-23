// Define the TopModule that directly extracts high and low bytes from the input
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use continuous assignments to extract the high and low bytes
    assign out_hi = in[15:8];  // Extract the high byte
    assign out_lo = in[7:0];   // Extract the low byte

endmodule