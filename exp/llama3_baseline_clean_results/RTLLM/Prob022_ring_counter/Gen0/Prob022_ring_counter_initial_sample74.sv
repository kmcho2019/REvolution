module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Shift the 1 to the next position, wrapping around to the start when reaching the end
        state <= {state[6:0], state[7]}; 
    end
end

assign out = state;

endmodule