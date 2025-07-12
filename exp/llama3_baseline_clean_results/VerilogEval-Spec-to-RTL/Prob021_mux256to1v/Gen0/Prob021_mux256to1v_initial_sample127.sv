module TopModule(
    input  [1023:0] in,  // 1024 bits input
    input  [7:0] sel,   // 8 bits select signal
    output [3:0] out    // 4 bits output
);

// Calculate the start bit position for the selected 4-bit input
wire [11:0] start_bit_pos = sel * 4;  // Multiply sel by 4 to get the start bit position

// Use the calculated start bit position to extract the 4-bit input from the input vector
assign out = in[start_bit_pos + 3 : start_bit_pos];  // Extract 4 bits starting from start_bit_pos

endmodule