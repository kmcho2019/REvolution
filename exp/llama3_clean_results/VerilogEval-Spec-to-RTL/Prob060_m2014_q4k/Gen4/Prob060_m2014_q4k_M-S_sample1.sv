// Module to implement a 4-bit shift register with synchronous reset
module TopModule(
    input clk,      // Clock signal
    input resetn,   // Active-low synchronous reset signal
    input in,      // Input bit
    output out     // Output bit
);

// 4-bit register to store the shifted bits
reg [3:0] shift_reg;

// Always block to update the shift register on the positive edge of the clock
always @(posedge clk) begin
    // Check for synchronous reset
    if (!resetn) begin
        // Reset the shift register to 0
        shift_reg <= 4'b0000;
    end else begin
        // Shift the input bit into the register
        shift_reg <= {in, shift_reg[3:1]};
    end
end

// Assign the least significant bit of the shift register to the output
assign out = shift_reg[0];

endmodule