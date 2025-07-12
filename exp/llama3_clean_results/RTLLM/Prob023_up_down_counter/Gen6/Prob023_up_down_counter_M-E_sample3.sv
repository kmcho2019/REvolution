module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [1:0] state;  // State machine state

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'd0;  // Reset state
        count <= 16'd0;  // Reset counter
    end else begin
        case (state)
            2'd0: begin  // Idle state
                if (up_down) begin
                    state <= 2'd1;  // Transition to increment state
                    count <= count + 1;  // Increment counter
                end else begin
                    state <= 2'd2;  // Transition to decrement state
                    count <= count - 1;  // Decrement counter
                end
            end
            2'd1: begin  // Increment state
                if (count == 16'd65535) begin
                    state <= 2'd0;  // Wrap around to idle state
                    count <= 16'd0;  // Reset counter
                end else begin
                    count <= count + 1;  // Increment counter
                end
            end
            2'd2: begin  // Decrement state
                if (count == 16'd0) begin
                    state <= 2'd0;  // Wrap around to idle state
                    count <= 16'd65535;  // Set counter to maximum value
                end else begin
                    count <= count - 1;  // Decrement counter
                end
            end
            default: begin
                state <= 2'd0;  // Reset state
                count <= 16'd0;  // Reset counter
            end
        endcase
    end
end

endmodule