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
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

reg [4:0] fall_counter;
reg walk_direction;

// Movement Module
always_comb begin
    walk_left = walk_direction ? 1'b0 : 1'b1;
    walk_right = walk_direction ? 1'b1 : 1'b0;
end

// Falling Module
always_ff @(posedge clk) begin
    if (areset || state == SPLATTERED) begin
        fall_counter <= 5'b0;
    end else if (state == FALLING) begin
        fall_counter <= fall_counter + 1'b1;
    end
end

// Digging Module
always_comb begin
    digging = (state == DIGGING) ? 1'b1 : 1'b0;
end

// History Keeper Module
always_ff @(posedge clk) begin
    if (areset) begin
        walk_direction <= 1'b0; // Default walking left
    end else if (bump_left || bump_right) begin
        walk_direction <= ~walk_direction;
    end
end

// State Transition Logic
always_comb begin
    next_state = state;
    case (state)
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED; // Stay in this state forever
        end
    endcase
end

// State Register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        aaah <= 1'b0;
    end else begin
        state <= next_state;
        aaah <= (state == FALLING) ? 1'b1 : 1'b0;
    end
end

// Output Assignment
always_comb begin
    walk_left = walk_direction ? 1'b0 : 1'b1;
    walk_right = walk_direction ? 1'b1 : 1'b0;
    digging = (state == DIGGING) ? 1'b1 : 1'b0;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
end

endmodule