module TopModule(
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    input        ground,
    input        dig,
    output       walk_left,
    output       walk_right,
    output       aaah,
    output       digging
);

localparam WALK = 2'd0,
           FALL = 2'd1,
           DIG  = 2'd2;

localparam LEFT  = 1'b0,
           RIGHT = 1'b1;

reg [1:0] mode, mode_next;
reg       dir, dir_next;

// Compute next mode (state) combinationally
always @(*) begin
    mode_next = mode;
    case (mode)
        WALK: begin
            if (!ground)
                mode_next = FALL;
            else if (dig)
                mode_next = DIG;
            else
                mode_next = WALK;
        end
        FALL: begin
            if (ground)
                mode_next = WALK;
            else
                mode_next = FALL;
        end
        DIG: begin
            if (!ground)
                mode_next = FALL;
            else
                mode_next = DIG;
        end
        default: mode_next = WALK;
    endcase
end

// Compute next direction: change only in WALK mode and on bump
always @(*) begin
    dir_next = dir;
    if (mode == WALK) begin
        if (bump_left && bump_right)
            dir_next = ~dir;
        else if (bump_left)
            dir_next = RIGHT;
        else if (bump_right)
            dir_next = LEFT;
    end
end

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir  <= LEFT;
    end else begin
        mode <= mode_next;
        dir  <= dir_next;
    end
end

// Outputs (Moore)
assign walk_left  = (mode == WALK) && (dir == LEFT);
assign walk_right = (mode == WALK) && (dir == RIGHT);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule