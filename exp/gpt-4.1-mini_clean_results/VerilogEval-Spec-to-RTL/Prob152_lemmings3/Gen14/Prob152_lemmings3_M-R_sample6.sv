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
    // Default assignments to hold current state
    mode_next = mode;
    dir_next = dir;

    case (mode)
        WALK: begin
            if (!ground) begin
                mode_next = FALL;
                // direction stays the same
            end else if (dig) begin
                mode_next = DIG;
            end else if (bump_left || bump_right) begin
                // Switch direction on bump, with bump on both sides toggling
                if (bump_left && bump_right)
                    dir_next = ~dir;
                else if (bump_left)
                    dir_next = 1'b1; // walk right
                else
                    dir_next = 1'b0; // walk left
            end
        end
        FALL: begin
            if (ground)
                mode_next = WALK;
            // no direction change while falling
        end
        DIG: begin
            if (!ground)
                mode_next = FALL;
            // direction unchanged while digging
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