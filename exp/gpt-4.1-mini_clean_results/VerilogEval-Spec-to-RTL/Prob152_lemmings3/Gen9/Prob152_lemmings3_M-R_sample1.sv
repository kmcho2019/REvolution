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

    // Modes: 2'b00 = walk, 2'b01 = fall, 2'b10 = dig
    localparam WALK = 2'b00,
               FALL = 2'b01,
               DIG  = 2'b10;

    reg [1:0] mode, next_mode;
    reg       dir, next_dir; // 0=left, 1=right

    wire bump = bump_left | bump_right;
    wire bump_any = bump_left | bump_right; // redundant but explicit for clarity

    // Next mode logic (combinational)
    always @(*) begin
        case (mode)
            WALK: begin
                if (!ground)
                    next_mode = FALL;
                else if (dig)
                    next_mode = DIG;
                else
                    next_mode = WALK;
            end
            FALL: begin
                if (ground)
                    next_mode = WALK;
                else
                    next_mode = FALL;
            end
            DIG: begin
                if (!ground)
                    next_mode = FALL;
                else
                    next_mode = DIG;
            end
            default: next_mode = WALK;
        endcase
    end

    // Next direction logic (combinational)
    always @(*) begin
        next_dir = dir; // default hold
        // Direction changes only when walking and bumped (ignore bumps if falling or digging)
        if (mode == WALK) begin
            // If bumped on left or right, flip direction
            if (bump_left || bump_right) begin
                next_dir = ~dir;
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            dir  <= 1'b0; // walk left
        end else begin
            mode <= next_mode;
            dir  <= next_dir;
        end
    end

    // Output decoding
    assign walk_left  = (mode == WALK) && (dir == 1'b0);
    assign walk_right = (mode == WALK) && (dir == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule