module TopModule(
    input clk,
    input areset,      // async posedge reset
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Modes
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] mode;
    reg direction;      // 0 = left, 1 = right
    reg [4:0] fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            direction <= 0;     // start walking left
            fall_timer <= 0;
        end else begin
            case (mode)
                SPLAT: begin
                    // stay splat forever
                    mode <= SPLAT;
                end
                FALL: begin
                    if (ground) begin
                        // landed
                        mode <= (fall_timer > 5'd20) ? SPLAT : WALK;
                        fall_timer <= 0;
                    end else begin
                        // continue falling; saturate at 31
                        fall_timer <= (fall_timer < 5'd31) ? fall_timer + 1 : fall_timer;
                    end
                end
                WALK: begin
                    if (!ground) begin
                        // start falling
                        mode <= FALL;
                        fall_timer <= 1;
                    end else if (dig) begin
                        mode <= DIG;
                    end else begin
                        // switch direction if bumped on left or right (or both)
                        if (bump_left && bump_right)
                            direction <= ~direction;
                        else if (bump_left)
                            direction <= 1;  // walk right
                        else if (bump_right)
                            direction <= 0;  // walk left
                    end
                end
                DIG: begin
                    if (!ground) begin
                        mode <= FALL;
                        fall_timer <= 1;
                    end
                    // else keep digging (ignore bumps and dig input)
                end
            endcase
        end
    end

    // Moore outputs
    assign walk_left  = (mode == WALK) && (direction == 0);
    assign walk_right = (mode == WALK) && (direction == 1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule