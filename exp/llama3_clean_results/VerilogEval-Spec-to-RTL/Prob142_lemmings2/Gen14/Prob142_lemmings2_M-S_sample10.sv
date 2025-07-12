module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

typedef enum logic [0:0] {
    WALK_LEFT,
    WALK_RIGHT
} walk_dir_t;

walk_dir_t walk_dir;
logic falling;

// Combinational logic to determine the next state
always_comb begin
    walk_dir_t next_walk_dir = walk_dir;
    logic next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1;
    end else if (ground && falling) begin
        next_falling = 1'b0;
    end else if (bump_left && ~falling) begin
        next_walk_dir = WALK_RIGHT;
    end else if (bump_right && ~falling) begin
        next_walk_dir = WALK_LEFT;
    end

    walk_dir = next_walk_dir;
    falling = next_falling;
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= WALK_LEFT;
        falling <= 1'b0;
    end else begin
        // Do nothing as the state is updated in the combinational block
    end
end

// Output logic using assign statements
assign walk_left = (walk_dir == WALK_LEFT) && ~falling;
assign walk_right = (walk_dir == WALK_RIGHT) && ~falling;
assign aaah = falling;

endmodule