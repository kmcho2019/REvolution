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

    // Mode encoding
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg [1:0] mode;  // 2-bit mode: walking, falling, digging
    reg dir;         // 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir  <= 1'b0; // walk left on reset
        end else begin
            case (mode)
                MODE_WALK: begin
                    if (!ground) begin
                        mode <= MODE_FALL; // fall has highest priority
                    end else if (dig) begin
                        mode <= MODE_DIG;  // dig if requested and grounded
                    end else if (bump_left || bump_right) begin
                        // switch direction on bump
                        // bump on both sides toggles direction
                        if (bump_left && bump_right)
                            dir <= ~dir;
                        else if (bump_left)
                            dir <= 1'b1;  // walk right
                        else
                            dir <= 1'b0;  // walk left
                    end
                    // else remain walking same direction
                end

                MODE_FALL: begin
                    if (ground)
                        mode <= MODE_WALK; // resume walking in original direction
                    // else remain falling
                end

                MODE_DIG: begin
                    if (!ground)
                        mode <= MODE_FALL; // fall after digging reaches edge
                    // else remain digging
                end

                default: begin
                    // Defensive default: go to walk left
                    mode <= MODE_WALK;
                    dir <= 1'b0;
                end
            endcase
        end
    end

    // Outputs (Moore outputs depend only on current state)
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule