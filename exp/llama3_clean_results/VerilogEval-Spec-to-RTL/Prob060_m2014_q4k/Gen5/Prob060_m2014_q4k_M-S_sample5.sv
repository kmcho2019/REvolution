// Module to implement a 4-bit shift register with synchronous reset
module TopModule(
    input clk,      // Clock signal
    input resetn,   // Active-low synchronous reset signal
    input in,      // Input bit
    output out     // Output bit
);

reg [3:0] shift_reg = 4'b0000; // Initialize the shift register

// Always block to update the shift register on the positive edge of the clock
always @(posedge clk) begin
    if (!resetn) // Synchronous reset condition
        shift_reg <= 4'b0000; // Reset the shift register
    else
        shift_reg <= {in, shift_reg[3:1]}; // Shift the input bit into the register
end

// Assign the least significant bit of the shift register to the output
assign out = shift_reg[0];

endmodule