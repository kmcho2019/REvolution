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

typedef enum logic [1:0] {
    WALK = 2'd0,
    FALL = 2'd1,
    DIG  = 2'd2
} state_t;

state_t state, next_state;
logic dir, next_dir; // 0 = left, 1 = right

always @* begin
    next_state = state;
    next_dir = dir;

    case(state)
        WALK: begin
            if (!ground)
                next_state = FALL;
            else if (dig)
                next_state = DIG;
            else if (bump_left && bump_right)
                next_dir = ~dir;
            else if (bump_left)
                next_dir = 1'b1; // walk right
            else if (bump_right)
                next_dir = 1'b0; // walk left
        end
        FALL: if (ground) next_state = WALK;
        DIG: if (!ground) next_state = FALL;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        dir <= 1'b0;
    end else begin
        state <= next_state;
        dir <= next_dir;
    end
end

assign walk_left  = (state == WALK) && (dir == 1'b0);
assign walk_right = (state == WALK) && (dir == 1'b1);
assign aaah       = (state == FALL);
assign digging    = (state == DIG);

endmodule