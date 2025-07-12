// Superior module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Temporary variable to accumulate the XOR result
reg temp_parity;

// Calculate the parity bit by hierarchically XORing all 8 bits together
always @(*) begin
    temp_parity = in[0] ^ in[1];
    temp_parity = temp_parity ^ (in[2] ^ in[3]);
    temp_parity = temp_parity ^ (in[4] ^ in[5]);
    temp_parity = temp_parity ^ (in[6] ^ in[7]);
end

// Assign the calculated parity to the output
assign parity = temp_parity;

endmodule