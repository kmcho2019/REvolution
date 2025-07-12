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
enum logic [1:0] {
    walking_left,
    walking_right,
    falling,
    digging
} state, next_state;

// Define the previous walking direction
logic prev_walk_left;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        prev_walk_left <= 1'b1;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        walking_left: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_left) begin
                next_state = walking_right;
                prev_walk_left <= 1'b0;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_right) begin
                next_state = walking_left;
                prev_walk_left <= 1'b1;
            end else if (bump_left) begin
                next_state = walking_right;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            aaah = 1'b1;
            if (ground) begin
                if (prev_walk_left) begin
                    next_state = walking_left;
                end else begin
                    next_state = walking_right;
                end
            end else begin
                next_state = falling;
            end
        end
        digging: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging;
            end
        end
        default: next_state = walking_left;
    endcase
end

endmodule