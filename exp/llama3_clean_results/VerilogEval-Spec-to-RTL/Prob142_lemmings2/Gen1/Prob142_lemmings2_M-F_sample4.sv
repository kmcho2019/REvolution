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

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        2'b00: begin // Walking Left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1) begin
                next_state = 2'b01; // Walking Right
            end else if (bump_right == 1'b1) begin
                next_state = 2'b01; // Walking Right
            end else begin
                next_state = 2'b00; // Still Walking Left
            end
        end
        2'b01: begin // Walking Right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00; // Walking Left
            end else if (bump_left == 1'b1) begin
                next_state = 2'b00; // Walking Left
            end else begin
                next_state = 2'b01; // Still Walking Right
            end
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    // Ignore bump signals while falling
                    if (current_state == 2'b10) begin
                        // Transition back to previous walking direction
                        if (bump_left == 1'b1 && bump_right == 1'b1) begin
                            // Switch direction if both bump signals are high
                            if (current_state == 2'b10) begin
                                next_state = (bump_left == 1'b1) ? 2'b01 : 2'b00;
                            end else begin
                                next_state = (bump_left == 1'b1) ? 2'b00 : 2'b01;
                            end
                        end else if (bump_left == 1'b1) begin
                            next_state = 2'b01; // Walking Right
                        end else if (bump_right == 1'b1) begin
                            next_state = 2'b00; // Walking Left
                        end else begin
                            // If no bump signals, retain previous direction
                            next_state = (current_state == 2'b00) ? 2'b00 : 2'b01;
                        end
                    end else begin
                        next_state = current_state;
                    end
                end else begin
                    // Transition back to previous walking direction
                    next_state = (current_state == 2'b00) ? 2'b00 : 2'b01;
                end
            end else begin
                next_state = current_state; // Still Falling
            end
        end
        default: begin // invalid state, should not happen
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            next_state = 2'b00; // default to Walking Left
        end
    endcase

    if (areset == 1'b1) begin
        next_state = 2'b00; // reset to Walking Left
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= 2'b00; // reset to Walking Left
    end else begin
        current_state <= next_state;
    end
end

initial begin
    current_state = 2'b00;
end

endmodule