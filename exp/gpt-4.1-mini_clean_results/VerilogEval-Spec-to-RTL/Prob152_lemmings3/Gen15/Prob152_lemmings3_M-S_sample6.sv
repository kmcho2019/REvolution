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
    // State encoding
    localparam WALK  = 2'd0;
    localparam FALL  = 2'd1;
    localparam DIG   = 2'd2;

    reg [1:0] state;
    reg dir; // 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // walk left
        end else begin
            case(state)
                FALL: begin
                    if (ground)
                        state <= WALK;
                end
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                end
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        // handle bumps
                        if (bump_left && bump_right)
                            dir <= ~dir;
                        else if (bump_left)
                            dir <= 1'b1; // walk right
                        else if (bump_right)
                            dir <= 1'b0; // walk left
                    end
                end
            endcase
        end
    end

    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule