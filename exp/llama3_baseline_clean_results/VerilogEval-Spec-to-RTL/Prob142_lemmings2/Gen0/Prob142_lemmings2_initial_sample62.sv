module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// State encoding: WL = 2'b00, WR = 2'b01, F = 2'b10
reg [1:0] state;
reg [1:0] prev_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
        prev_state <= 2'b00; // Reset previous state to walking left
    end else begin
        case (state)
            2'b00: begin // Walking left
                if (~ground) begin
                    state <= 2'b10; // Start falling
                    prev_state <= 2'b00; // Store previous state as walking left
                end else if (bump_left) begin
                    state <= 2'b01; // Switch to walking right
                end
            end
            2'b01: begin // Walking right
                if (~ground) begin
                    state <= 2'b10; // Start falling
                    prev_state <= 2'b01; // Store previous state as walking right
                end else if (bump_right) begin
                    state <= 2'b00; // Switch to walking left
                end
            end
            2'b10: begin // Falling
                if (ground) begin
                    state <= prev_state; // Resume walking in previous direction
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // Walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule