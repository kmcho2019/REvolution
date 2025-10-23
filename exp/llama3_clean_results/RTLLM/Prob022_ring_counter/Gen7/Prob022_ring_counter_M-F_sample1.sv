module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] current_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Calculate the next state based on the current state
        if (current_state == 8'b1000_0000) begin
            current_state <= 8'b0000_0001; // Wrap around to the LSB
        end else begin
            // Shift the bits to the left, wrapping around if necessary
            reg [7:0] next_state;
            next_state = (current_state << 1) | (current_state[7] ? 8'b0000_0001 : 8'b0000_0000);
            current_state <= next_state;
        end
    end
end

assign out = current_state;

endmodule