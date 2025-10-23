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

    // Mode encoding for clarity and minimal state bits
    localparam MODE_WALK = 2'd0,
               MODE_FALL = 2'd1,
               MODE_DIG  = 2'd2;

    reg [1:0] mode;
    reg dir; // 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir <= 1'b0; // start walking left
        end else begin
            case (mode)
                MODE_WALK: begin
                    if (!ground) begin
                        // Fall has highest priority
                        mode <= MODE_FALL;
                    end else if (dig) begin
                        // Digging second priority
                        mode <= MODE_DIG;
                    end else if (bump_left || bump_right) begin
                        // Direction switch only when walking on ground and no fall/dig
                        if (bump_left && bump_right) begin
                            dir <= ~dir;
                        end else if (bump_left) begin
                            dir <= 1'b1; // walk right
                        end else begin
                            dir <= 1'b0; // walk left
                        end
                    end
                    // else remain walking same direction
                end
                MODE_FALL: begin
                    if (ground) begin
                        // Stop falling when ground reappears, resume walking same direction
                        mode <= MODE_WALK;
                    end
                    // else remain falling, direction unchanged
                end
                MODE_DIG: begin
                    if (!ground) begin
                        // Digging ended by falling
                        mode <= MODE_FALL;
                    end
                    // else continue digging, direction unchanged
                end
                default: begin
                    // Safe default: go to walking left
                    mode <= MODE_WALK;
                    dir <= 1'b0;
                end
            endcase
        end
    end

    // Moore outputs based on mode and direction
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule