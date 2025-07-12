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

// Define the main states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10
} state, next_state;

// Define the walking direction
reg walk_dir;
reg next_walk_dir;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_dir <= 1'b0; // initial direction is left
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_walk_dir = walk_dir;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_walk_dir = ~walk_dir;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Combinational logic for outputs
assign walk_left = (state == WALKING &&!walk_dir);
assign walk_right = (state == WALKING && walk_dir);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule