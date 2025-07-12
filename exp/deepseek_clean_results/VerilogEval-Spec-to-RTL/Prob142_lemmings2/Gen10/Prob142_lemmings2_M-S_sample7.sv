module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // States
    parameter WALK = 0;
    parameter FALL = 1;
    
    reg state;
    reg dir;  // 0=left, 1=right
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground) state <= FALL;
                else if (bump_left || bump_right) dir <= dir ^ (bump_left | bump_right);
            end
            FALL: if (ground) state <= WALK;
        endcase
    end
    
    assign walk_left = (state == WALK) & ~dir;
    assign walk_right = (state == WALK) & dir;
    assign aaah = (state == FALL);

endmodule