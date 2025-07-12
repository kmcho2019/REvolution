module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the shift amount based on the select signal
wire [11:0] shift_amount = {4'b0, sel} << 2;

// Shift the input vector to the right by the shift amount
wire [1023:0] shifted_in = in >> shift_amount;

// Create a mask vector with ones only in the most significant 4 bits
wire [1023:0] mask = {4'b1111, {1020{1'b0}}};

// Perform bitwise AND operation to extract the desired 4-bit output
assign out = shifted_in[3:0] & mask[3:0];

endmodule