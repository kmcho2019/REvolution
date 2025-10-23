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
enum logic [2:0] {walking_left, walking_right, falling, digging, splattered} state, next_state;

// Counter to keep track of the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

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

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    next_state = state;

    case (state)
        walking_left: begin
            walk_left = 1;
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            walk_right = 1;
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_right;
            end
        end
        falling: begin
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = splattered;
                end else if (dig) begin
                    next_state = walking_left; // assuming the Lemming starts walking left after digging
                end else if (state == walking_left) begin
                    next_state = walking_left;
                end else if (state == walking_right) begin
                    next_state = walking_right;
                end
            end
        end
        digging: begin
            digging = 1;
            if (!ground) begin
                next_state = falling;
            end
        end
        splattered: begin
            // do nothing
        end
    endcase
end

endmodule