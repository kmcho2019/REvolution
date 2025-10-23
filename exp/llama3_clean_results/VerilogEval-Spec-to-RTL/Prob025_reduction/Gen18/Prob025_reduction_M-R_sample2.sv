// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Temporary variable to accumulate the XOR result
reg temp_parity;

// Calculate the parity bit by XORing all 8 bits together
always @(*) begin
    temp_parity = in[0];
    for (int i = 1; i < 8; i++) begin
        temp_parity = temp_parity ^ in[i];
    end
end

// Assign the calculated parity to the output
assign parity = temp_parity;

endmodule