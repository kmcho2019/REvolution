module TopModule (
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

// Define the counter for falling
logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_left || (bump_left && bump_right)) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_right || (bump_left && bump_right)) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule