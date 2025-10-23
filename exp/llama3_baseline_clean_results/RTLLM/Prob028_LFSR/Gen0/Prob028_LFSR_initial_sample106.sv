module LFSR (
    input clk,      // Clock signal
    input rst,      // Active high reset signal
    output [3:0] out // 4-bit output
);

reg [3:0] state;    // Register to hold the current state

// Feedback calculation: XOR of MSB and second MSB, then invert
assign out = state;
always @(posedge clk) begin
    if (rst) begin
        // Reset the register to zero on active high reset
        state <= 4'b0000;
    end else begin
        // Shift bits left and insert new feedback value at LSB
        state <= {state[2] ^ state[3], state[3:1]};
    end
end

endmodule