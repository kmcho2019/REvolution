module TopModule (
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

    parameter WALK = 0;
    parameter FALL = 1;
    parameter DIG  = 2;
    
    reg [1:0] state;
    reg dir;  // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
        end else case (state)
            WALK: begin
                if (!ground) state <= FALL;
                else if (dig) state <= DIG;
                else if (bump_left && !dir) dir <= 1;
                else if (bump_right && dir) dir <= 0;
            end
            FALL: if (ground) state <= WALK;
            DIG: if (!ground) state <= FALL;
        endcase
    end

    assign walk_left = (state == WALK) && !dir;
    assign walk_right = (state == WALK) && dir;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule