module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] out_reg;
reg [2:0] state; // Since 2^3 = 8, we need 3 bits to represent the state

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Reset state to 0
        out_reg <= 8'b0000_0001; // Reset output to initial state
    end else begin
        if (state == 3'b111) begin // If we've reached the last state
            state <= 3'b000; // Wrap around to the first state
        end else begin
            state <= state + 1; // Increment state
        end
        out_reg <= 1 << state; // Set the output bit corresponding to the current state
    end
end

assign out = out_reg;

endmodule