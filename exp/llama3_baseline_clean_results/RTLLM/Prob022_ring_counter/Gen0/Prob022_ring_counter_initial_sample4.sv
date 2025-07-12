module ring_counter(
    input clk, 
    input reset, 
    output [7:0] out
);

reg [7:0] current_state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 8'b0000_0001; // Initialize to the starting state when reset is high
    end else begin
        // Shift the set bit to the next position, and wrap around to the LSB after reaching the MSB
        current_state <= {current_state[6:0], current_state[7]};
    end
end

assign out = current_state;

endmodule