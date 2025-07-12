module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding:
// state[1] = 0: walking, state[1] = 1: falling
// state[0] = 0: walking left, state[0] = 1: walking right

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_left) begin
                next_state = 2'b01; // walking right
            end else if (bump_right) begin
                next_state = 2'b01; // walking right
            end else begin
                next_state = 2'b00; // walking left
            end
        end
        2'b01: begin // walking right
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_left) begin
                next_state = 2'b00; // walking left
            end else if (bump_right) begin
                next_state = 2'b00; // walking left
            end else begin
                next_state = 2'b01; // walking right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                // If the Lemmings were walking left before falling, they will continue walking left
                // If the Lemmings were walking right before falling, they will continue walking right
                if (state == 2'b10 && bump_left == 1'b1 && bump_right == 1'b1) begin
                    next_state = state; // still falling
                end else if (state == 2'b10 && bump_left == 1'b1 && bump_right == 1'b0) begin
                    next_state = 2'b01; // walking right
                end else if (state == 2'b10 && bump_left == 1'b0 && bump_right == 1'b1) begin
                    next_state = 2'b00; // walking left
                end else if (state == 2'b10 && bump_left == 1'b0 && bump_right == 1'b0) begin
                    next_state = state; // still falling
                end else begin
                    next_state = 2'b00; // walking left
                end
            end else begin
                next_state = 2'b10; // still falling
            end
        end
        default: begin
            next_state = 2'b00; // walking left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
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
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule