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

enum logic [1:0] {FALLING, WALKING, DIGGING} state, next_state;
reg walk_direction, next_walk_direction;
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 0; // left
        prev_ground <= 1;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    case (state)
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_walk_direction = 1; // right
            end else if (bump_right) begin
                next_walk_direction = 0; // left
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

assign walk_left = (state == WALKING && !walk_direction) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule