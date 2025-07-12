// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Temporary variable to store the result of XOR operation
wire temp;

// Calculate the even parity bit by performing an XOR operation on all input bits
assign temp = ^in;  
assign parity = temp;  // Assign the result to the output parity bit

endmodule