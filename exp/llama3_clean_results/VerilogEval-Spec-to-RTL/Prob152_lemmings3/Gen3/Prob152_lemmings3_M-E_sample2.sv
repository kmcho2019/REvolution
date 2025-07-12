module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the outer level states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING_STATE = 2'b10
} outer_state, next_outer_state;

// Define the inner level states
enum logic {
    LEFT = 1'b0,
    RIGHT = 1'b1
} inner_state, next_inner_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        outer_state <= WALKING;
        inner_state <= LEFT;
    end else begin
        outer_state <= next_outer_state;
        inner_state <= next_inner_state;
    end
end

// Combinational logic
always_comb begin
    next_outer_state = outer_state;
    next_inner_state = inner_state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (outer_state)
        WALKING: begin
            if (inner_state == LEFT) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end

            if (!ground) begin
                next_outer_state = FALLING;
            end else if (dig) begin
                next_outer_state = DIGGING_STATE;
            end else if (bump_left || bump_right) begin
                if (inner_state == LEFT) begin
                    next_inner_state = RIGHT;
                end else begin
                    next_inner_state = LEFT;
                end
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                next_outer_state = WALKING;
            end
        end
        DIGGING_STATE: begin
            digging = 1'b1;
            if (!ground) begin
                next_outer_state = FALLING;
            end
        end
    endcase
end

endmodule