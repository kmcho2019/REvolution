module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// State machine states
enum logic [1:0] {RESET, COUNT} state, next_state;

// State machine
always @ (posedge clk) begin
    if (reset) begin
        state <= RESET;
    end else begin
        state <= COUNT;
    end
end

// Counter logic
always @ (posedge clk) begin
    case (state)
        RESET: begin
            // Reset the counter to zero
            count <= 16'd0;
        end
        COUNT: begin
            // Check the up_down control signal to determine the counting direction
            if (up_down) begin
                // Increment the counter when up_down is high
                count <= count + 1;
            end else begin
                // Decrement the counter when up_down is low
                count <= count - 1;
            end
        end
    endcase
end

endmodule