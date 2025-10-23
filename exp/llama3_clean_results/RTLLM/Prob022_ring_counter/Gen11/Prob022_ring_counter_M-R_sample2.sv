module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] state; // 8-bit register to hold the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Reset the state to the initial condition
    end else begin
        // Compute the next state by shifting the current state one bit to the left and wrapping around
        state <= {state[6:0], state[7]}; // Shift left and wrap the MSB to the LSB
    end
    out <= state; // Assign the current state to the output
end

endmodule