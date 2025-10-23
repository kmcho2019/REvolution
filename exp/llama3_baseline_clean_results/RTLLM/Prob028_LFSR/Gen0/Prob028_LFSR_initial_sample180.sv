module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Register to store the current state of the LFSR
assign out = state; // Assign the current state to the output

always @(posedge clk) begin
    if (rst) begin // If reset is high
        state <= 4'b0; // Initialize the register to zero
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, and then inverting the result
        reg [3:0] next_state;
        next_state = {state[2:0], ~(state[3] ^ state[2])};
        state <= next_state; // Shift the bits and insert the new feedback value at the LSB
    end
end

endmodule