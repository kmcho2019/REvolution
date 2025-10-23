module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Enumerate the states
    typedef enum logic [1:0] {
        walking_left = 2'b00,
        walking_right = 2'b01,
        falling_left = 2'b10,
        falling_right = 2'b11
    } state_t;

    state_t current_state;
    state_t next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            walking_left: begin
                if (~ground) begin
                    if (bump_left || bump_right)
                        next_state = falling_left;
                    else
                        next_state = falling_left;
                end else if (bump_left) begin
                    next_state = walking_right;
                end else if (bump_right) begin
                    next_state = walking_left;
                end else begin
                    next_state = walking_left;
                end
            end
            walking_right: begin
                if (~ground) begin
                    if (bump_left || bump_right)
                        next_state = falling_right;
                    else
                        next_state = falling_right;
                end else if (bump_left) begin
                    next_state = walking_left;
                end else if (bump_right) begin
                    next_state = walking_right;
                end else begin
                    next_state = walking_right;
                end
            end
            falling_left: begin
                if (ground) begin
                    next_state = walking_left;
                end else begin
                    next_state = falling_left;
                end
            end
            falling_right: begin
                if (ground) begin
                    next_state = walking_right;
                end else begin
                    next_state = falling_right;
                end
            end
            default: next_state = walking_left;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= walking_left;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always_comb begin
        case (current_state)
            walking_left: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
            walking_right: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
            falling_left: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
            falling_right: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end
endmodule