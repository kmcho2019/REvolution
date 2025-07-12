// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output reg parity  // 1-bit output for even parity
);

// Use an always block with a loop to calculate the parity
always @(*) begin
    parity = 1'b0;  // Initialize parity to 0
    for (int i = 0; i < 8; i++) begin
        // XOR each bit of the input with the current parity
        parity = parity ^ in[i];
    end
end

endmodule