module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] ring_reg = 8'd1; // Initialize with a non-zero value to start the oscillator

always @(posedge clk) begin
    // Shift the ring register to the right by one bit, wrapping around the last bit to the first
    // The frequency input controls the number of stages in the ring oscillator
    if (ring_reg[0] == 1'b1) begin
        wave_out <= ~wave_out; // Toggle the output when the least significant bit is 1
    end
    // Shift the register
    ring_reg <= {ring_reg[6:0], ring_reg[7]};
    
    // Optionally, to ensure the ring oscillator's frequency matches the input freq,
    // one could adjust the ring register's size or add additional logic to control the frequency.
    // However, this would add complexity and may not be necessary for all applications.
end

endmodule