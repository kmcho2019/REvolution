module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states
enum logic [2:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define flags
reg is_falling;
reg is_digging;
reg direction; // 0 for left, 1 for right
reg [4:0] fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        is_digging <= 1'b0;
        is_falling <= 1'b0;
    end else begin
        state <= next_state;
        fall_counter <= (is_falling) ? fall_counter + 1'b1 : 5'b0;
        is_digging <= (state == DIGGING && dig) ? 1'b1 : (state == WALKING && !dig) ? 1'b0 : is_digging;
        is_falling <= (state == FALLING || (state == WALKING && !ground)) ? 1'b1 : (state == WALKING && ground) ? 1'b0 : is_falling;
        direction <= (bump_left || bump_right) ? ~direction : direction;
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
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                // do nothing, direction is handled in sequential logic
            end
            walk_left = (direction == 1'b0) ? 1'b1 : 1'b0;
            walk_right = (direction == 1'b1) ? 1'b1 : 1'b0;
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
            digging = 1'b1;
        end
        SPLATTERED: begin
            // do nothing
        end
    endcase
end

endmodule