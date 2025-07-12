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
    walking_left,
    walking_right,
    falling,
    digging_state,
    splattered
} state, next_state;

// Define the counter for falling
logic [5:0] fall_counter, next_fall_counter;

// Define the direction of the Lemming
logic [0:0] direction, next_direction;

always_comb begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_direction = direction;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        walking_left: begin
            walk_left = 1'b1;
            if (dig && ground) begin
                next_state = digging_state;
            end else if (!ground) begin
                next_state = falling;
                next_fall_counter = 1'b1;
            end else if (bump_left) begin
                next_state = walking_right;
                next_direction = 1'b1;
            end else if (bump_right) begin
                next_state = walking_left;
                next_direction = 1'b0;
            end
        end
        walking_right: begin
            walk_right = 1'b1;
            if (dig && ground) begin
                next_state = digging_state;
            end else if (!ground) begin
                next_state = falling;
                next_fall_counter = 1'b1;
            end else if (bump_left) begin
                next_state = walking_left;
                next_direction = 1'b0;
            end else if (bump_right) begin
                next_state = walking_left;
                next_direction = 1'b0;
            end
        end
        falling: begin
            aaah = 1'b1;
            next_fall_counter = fall_counter + 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = splattered;
                end else begin
                    next_state = (direction == 1'b1) ? walking_right : walking_left;
                end
            end
        end
        digging_state: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = falling;
                next_fall_counter = 1'b1;
            end
        end
        splattered: begin
            // Do nothing
        end
        default: begin
            // Do nothing
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        fall_counter <= 6'b0;
        direction <= 1'b0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        direction <= next_direction;
    end
end

endmodule