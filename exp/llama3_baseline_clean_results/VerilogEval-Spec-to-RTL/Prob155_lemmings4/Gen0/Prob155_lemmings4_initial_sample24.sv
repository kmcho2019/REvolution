module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the counter for falling clock cycles
logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_right == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                next_state = WALK_LEFT;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (fall_counter > 6'd20) begin
                    next_state = SPLATTERED;
                end else if (state == FALLING && dig == 1'b1) begin
                    next_state = state; // ignore dig while falling
                end else if (state == FALLING && (bump_left == 1'b1 || bump_right == 1'b1)) begin
                    next_state = state; // ignore bumps while falling
                end else begin
                    if (state == FALLING && ground == 1'b1) begin
                        if (state == FALLING && (bump_left == 1'b1 || bump_right == 1'b1)) begin
                            next_state = state; // ignore bumps when hitting ground while falling
                        end else begin
                            next_state = WALK_LEFT; // resume walking left after falling
                        end
                    end else begin
                        next_state = state; // keep falling
                    end
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                next_state = state; // ignore bumps while digging
            end
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            next_state = SPLATTERED;
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

endmodule