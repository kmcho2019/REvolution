module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [1:0] state;  // State machine states: idle (2'b00), increment (2'b01), decrement (2'b10)
reg [15:0] next_count;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;  // Reset state to idle
        count <= 16'd0;  // Reset counter to 0
    end else begin
        case (state)
            2'b00: begin  // Idle state
                if (up_down) begin
                    state <= 2'b01;  // Transition to increment state
                end else if (!up_down) begin
                    state <= 2'b10;  // Transition to decrement state
                end
            end
            2'b01: begin  // Increment state
                count <= (count + 1) % 65536;  // Increment counter
                if (!up_down) begin
                    state <= 2'b00;  // Transition back to idle state
                end
            end
            2'b10: begin  // Decrement state
                count <= (count - 1 + 65536) % 65536;  // Decrement counter
                if (up_down) begin
                    state <= 2'b00;  // Transition back to idle state
                end
            end
        endcase
    end
end

endmodule