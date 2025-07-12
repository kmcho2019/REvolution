module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the state encoding
// 2'b00: Walking Left
// 2'b01: Walking Right
// 2'b10: Falling

reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Walking Left
            if(!ground) begin
                next_state = 2'b10; // Start falling
            end else if(bump_left) begin
                next_state = 2'b01; // Switch to walking right
            end else begin
                next_state = 2'b00; // Continue walking left
            end
        end
        2'b01: begin // Walking Right
            if(!ground) begin
                next_state = 2'b10; // Start falling
            end else if(bump_right) begin
                next_state = 2'b00; // Switch to walking left
            end else begin
                next_state = 2'b01; // Continue walking right
            end
        end
        2'b10: begin // Falling
            if(ground) begin
                // Resume previous direction
                if(bump_left && bump_right) begin
                    // If both bump signals are high, don't change direction
                    if(state == 2'b00) begin
                        next_state = 2'b01;
                    end else begin
                        next_state = 2'b00;
                    end
                end else if(bump_left) begin
                    next_state = 2'b01;
                end else if(bump_right) begin
                    next_state = 2'b00;
                end else begin
                    // If no bumps, stay in the previous direction
                    if(state == 2'b00) begin
                        next_state = 2'b00;
                    end else begin
                        next_state = 2'b01;
                    end
                end
            end else begin
                next_state = 2'b10; // Continue falling
            end
        end
        default: next_state = 2'b00; // Default to walking left
    endcase
end

// Output logic
always @(*) begin
    case(state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
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