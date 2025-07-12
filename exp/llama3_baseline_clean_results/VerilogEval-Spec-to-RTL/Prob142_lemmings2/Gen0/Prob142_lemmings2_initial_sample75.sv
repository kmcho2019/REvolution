module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding:
// 0: Walking left
// 1: Walking right
// 2: Falling

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            if (bump_left) begin
                next_state = 2'b01; // Switch to walking right
            end else if (ground == 0) begin
                next_state = 2'b10; // Start falling
            end else begin
                next_state = 2'b00; // Stay walking left
            end
        end
        2'b01: begin // Walking right
            if (bump_right) begin
                next_state = 2'b00; // Switch to walking left
            end else if (ground == 0) begin
                next_state = 2'b10; // Start falling
            end else begin
                next_state = 2'b01; // Stay walking right
            end
        end
        2'b10: begin // Falling
            if (ground) begin
                if (bump_left == 0 && bump_right == 0) begin
                    if (bump_left == 0 && bump_right == 0) begin
                        next_state = state == 2'b10? 2'b00 : 2'b01; // Resume walking
                    end else if (bump_left == 1) begin
                        next_state = 2'b01; // Switch to walking right
                    end else if (bump_right == 1) begin
                        next_state = 2'b00; // Switch to walking left
                    end
                end else begin
                    next_state = 2'b10; // Keep falling
                end
            end else begin
                next_state = 2'b10; // Keep falling
            end
        end
        default: next_state = 2'b00; // Default state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= next_state; // Update state
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
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule