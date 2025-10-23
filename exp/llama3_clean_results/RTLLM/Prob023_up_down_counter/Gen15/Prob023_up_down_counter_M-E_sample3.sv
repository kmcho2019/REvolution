module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Define the FSM states
enum logic [0:0] {INCREMENT, DECREMENT} state, next_state;

always @ (posedge clk) begin
    if (reset) begin
        state <= INCREMENT;
        count <= 16'd0;
    end else begin
        state <= next_state;
        if (state == INCREMENT) begin
            count <= (count == 16'd65535)? 16'd0 : count + 1;
        end else if (state == DECREMENT) begin
            count <= (count == 16'd0)? 16'd65535 : count - 1;
        end
    end
end

always @ (*) begin
    if (up_down) begin
        next_state = INCREMENT;
    end else begin
        next_state = DECREMENT;
    end
end

endmodule