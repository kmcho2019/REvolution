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

localparam WALK = 2'd0,
           FALL = 2'd1,
           DIG  = 2'd2;

reg [1:0] mode, mode_next;
reg dir, dir_next;

always @(*) begin
    mode_next = mode;
    dir_next = dir;

    case (mode)
        WALK: begin
            if (!ground)
                mode_next = FALL;
            else if (dig)
                mode_next = DIG;
            else if (bump_left || bump_right)
                dir_next = (bump_left && bump_right) ? ~dir :
                           (bump_left ? 1'b1 : 1'b0);
        end
        FALL: begin
            if (ground)
                mode_next = WALK;
        end
        DIG: begin
            if (!ground)
                mode_next = FALL;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir <= 1'b0; // start walking left
    end else begin
        mode <= mode_next;
        dir <= dir_next;
    end
end

assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule