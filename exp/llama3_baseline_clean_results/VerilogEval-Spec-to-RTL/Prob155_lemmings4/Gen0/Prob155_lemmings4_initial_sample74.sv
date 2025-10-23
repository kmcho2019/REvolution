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
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Define the counter for tracking the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 6'b0;
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
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_counter > 6'b10100) begin // 20 clock cycles
                    next_state = SPLATTERED;
                end else begin
                    if (state == FALLING) begin
                        if (state == WALK_LEFT) begin
                            next_state = WALK_LEFT;
                        end else if (state == WALK_RIGHT) begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule