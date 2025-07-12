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

// Enumerate the states
enum logic [2:0] {
    WalkingLeft,
    WalkingRight,
    Falling,
    Digging,
    Splattered
} state, next_state;

// Variable to keep track of the number of clock cycles spent falling
logic [4:0] fall_counter;

// Variable to keep track of the previous walking direction
logic prev_walk_left;

// Combinational logic for next state and output calculation
always_comb begin
    // Defaults
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WalkingLeft: begin
            if (!ground) begin
                next_state = Falling;
            end else if (dig) begin
                next_state = Digging;
            end else if (bump_right) begin
                next_state = WalkingRight;
            end else if (bump_left) begin
                // Do nothing, already walking left
            end
            walk_left = 1'b1;
        end
        WalkingRight: begin
            if (!ground) begin
                next_state = Falling;
            end else if (dig) begin
                next_state = Digging;
            end else if (bump_left) begin
                next_state = WalkingLeft;
            end else if (bump_right) begin
                // Do nothing, already walking right
            end
            walk_right = 1'b1;
        end
        Falling: begin
            if (ground) begin
                if (fall_counter >= 5'd20) begin
                    next_state = Splattered;
                end else begin
                    if (prev_walk_left) begin
                        next_state = WalkingLeft;
                    end else begin
                        next_state = WalkingRight;
                    end
                end
            end
            aaah = 1'b1;
        end
        Digging: begin
            if (!ground) begin
                next_state = Falling;
            end
            digging = 1'b1;
        end
        Splattered: begin
            // Do nothing
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WalkingLeft;
        fall_counter <= 5'd0;
        prev_walk_left <= 1'b1;
    end else begin
        case (state)
            WalkingLeft: begin
                prev_walk_left <= 1'b1;
            end
            WalkingRight: begin
                prev_walk_left <= 1'b0;
            end
            Falling: begin
                fall_counter <= fall_counter + 1'b1;
            end
            default: begin
                fall_counter <= 5'd0;
            end
        endcase
        state <= next_state;
    end
end

endmodule