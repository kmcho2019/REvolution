module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] current_count;
reg [15:0] next_count;

// State machine states
reg [1:0] state;
reg [1:0] next_state;

// State machine transitions
always @ (*) begin
    case (state)
        2'b00: begin // Reset state
            if (~reset) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // Count state
            if (reset) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

// ALU for increment/decrement logic
always @ (*) begin
    if (up_down) begin
        next_count = current_count + 1;
    end else begin
        next_count = current_count - 1;
    end
end

// Update state and count registers
always @ (posedge clk) begin
    state <= next_state;
    if (state == 2'b00) begin
        count <= 16'd0;
    end else if (state == 2'b01) begin
        count <= next_count;
    end
    current_count <= count;
end

endmodule