// Module to calculate the even parity bit for an 8-bit input byte using a shift register approach
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [7:0] shift_reg; // Internal shift register to hold the input byte
reg parity_reg;      // Register to hold the calculated parity bit

always @(posedge in) begin // Update the shift register and calculate parity on every positive edge of in
    shift_reg <= in;        // Load the input byte into the shift register
    parity_reg <= 1'b0;     // Initialize the parity bit to 0
    for (int i = 0; i < 8; i++) begin // Iterate over each bit in the byte
        parity_reg <= parity_reg ^ shift_reg[7]; // XOR the current parity with the most significant bit of the shift register
        shift_reg <= {1'b0, shift_reg[7:1]};    // Shift the bits in the shift register one position to the right
    end
end

assign parity = parity_reg; // Assign the calculated parity to the output

endmodule