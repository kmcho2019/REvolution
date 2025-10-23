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

localparam WALK = 2'b00,
           FALL = 2'b01,
           DIG  = 2'b10;

reg [1:0] mode; // 2-bit mode
reg dir;        // 0=left, 1=right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir <= 1'b0; // walk left
    end else begin
        case (mode)
            WALK: begin
                if (!ground) begin
                    mode <= FALL;
                end else if (dig) begin
                    mode <= DIG;
                end else if (bump_left || bump_right) begin
                    // Bump precedence: both bumps invert, else bump left => right, bump right => left
                    if (bump_left && bump_right)
                        dir <= ~dir;
                    else if (bump_left)
                        dir <= 1'b1;
                    else
                        dir <= 1'b0;
                end
            end
            FALL: begin
                if (ground)
                    mode <= WALK;
            end
            DIG: begin
                if (!ground)
                    mode <= FALL;
            end
            default: mode <= WALK;
        endcase
    end
end

assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule