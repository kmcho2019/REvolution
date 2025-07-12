module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] state; // 8-bit register to hold the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Reset the state to the initial condition
        out <= state;
    end else begin
        // Shift the bits to the left and wrap the MSB to the LSB
        state <= {state[6:0], state[7]}; // Equivalent to shifting left and wrapping around
        out <= state;
    end
end

endmodule