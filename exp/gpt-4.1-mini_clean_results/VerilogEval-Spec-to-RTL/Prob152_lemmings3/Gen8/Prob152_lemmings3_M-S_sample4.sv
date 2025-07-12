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

localparam MODE_WALK = 2'd0;
localparam MODE_FALL = 2'd1;
localparam MODE_DIG  = 2'd2;

reg [1:0] mode;
reg dir; // 0=left, 1=right

reg [1:0] next_mode;
reg next_dir;

always @(*) begin
    next_mode = mode;
    next_dir = dir;

    if (mode == MODE_WALK) begin
        if (!ground) begin
            next_mode = MODE_FALL;
        end else if (dig) begin
            next_mode = MODE_DIG;
        end else begin
            if (bump_left && bump_right) next_dir = ~dir;
            else if (bump_left) next_dir = 1'b1;
            else if (bump_right) next_dir = 1'b0;
        end
    end else if (mode == MODE_FALL) begin
        if (ground) next_mode = MODE_WALK;
    end else if (mode == MODE_DIG) begin
        if (!ground) next_mode = MODE_FALL;
    end else begin
        next_mode = MODE_WALK;
        next_dir = 1'b0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        dir <= 1'b0;
    end else begin
        mode <= next_mode;
        dir <= next_dir;
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule