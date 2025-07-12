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

// Define states
enum logic [2:0] {
    walking_left,
    walking_right,
    falling,
    digging_state,
    splattered
} state, next_state;

// Define variables to store original direction and counter for falling
logic original_direction;
logic [4:0] fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == falling) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        walking_left: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = falling;
                original_direction = 1'b1; // walking left
            end else if (dig) begin
                next_state = digging_state;
                original_direction = 1'b1; // walking left
            end else if (bump_right) begin
                next_state = walking_right;
            end else if (bump_left) begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = falling;
                original_direction = 1'b0; // walking right
            end else if (dig) begin
                next_state = digging_state;
                original_direction = 1'b0; // walking right
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_right;
            end
        end
        falling: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = splattered;
                end else if (original_direction) begin
                    next_state = walking_left;
                end else begin
                    next_state = walking_right;
                end
            end
        end
        digging_state: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = falling;
            end else if (original_direction) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
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

endmodule