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

reg [1:0] mode;
reg dir; // 0=left, 1=right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir <= 1'b0; // start walking left
    end else begin
        case (mode)
            WALK: begin
                if (!ground) 
                    mode <= FALL;
                else if (dig) 
                    mode <= DIG;
                else if (bump_left || bump_right) 
                    dir <= ~dir; // flip direction on any bump
            end
            FALL: begin
                if (ground)
                    mode <= WALK;
            end
            DIG: begin
                if (!ground)
                    mode <= FALL;
            end
        endcase
    end
end

assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule