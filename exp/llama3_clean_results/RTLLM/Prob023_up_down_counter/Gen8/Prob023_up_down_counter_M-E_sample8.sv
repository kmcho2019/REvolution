module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [1:0] state; // State of the FSM: 00 - reset, 01 - increment, 10 - decrement
reg [15:0] next_count; // Next value of the counter

// FSM to manage the direction and reset signals
always @ (posedge clk) begin
    case (state)
        2'b00: begin // Reset state
            if (!reset) begin
                state <= (up_down) ? 2'b01 : 2'b10;
            end
        end
        2'b01: begin // Increment state
            if (reset) begin
                state <= 2'b00;
            end else if (!up_down) begin
                state <= 2'b10;
            end
        end
        2'b10: begin // Decrement state
            if (reset) begin
                state <= 2'b00;
            end else if (up_down) begin
                state <= 2'b01;
            end
        end
    endcase
end

// Counter logic
always @ (posedge clk) begin
    case (state)
        2'b00: begin // Reset state
            next_count <= 16'd0;
        end
        2'b01: begin // Increment state
            next_count <= (count == 16'd65535) ? 16'd0 : count + 1;
        end
        2'b10: begin // Decrement state
            next_count <= (count == 16'd0) ? 16'd65535 : count - 1;
        end
    endcase
end

// Register the next state
always @ (posedge clk) begin
    count <= next_count;
end

endmodule