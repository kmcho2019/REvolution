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

    reg state;      // 0=WALK, 1=FALL
    reg direction;  // 0=left, 1=right
    reg is_digging; // 1 when digging

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK
            direction <= 0;     // left
            is_digging <= 0;
        end
        else begin
            if (!ground) begin  // Highest priority: fall
                state <= 1;
                is_digging <= 0;
            end
            else if (state) begin // Currently falling
                state <= 0;      // Return to walking when ground reappears
            end
            else begin // WALK state
                if (dig) begin
                    is_digging <= 1;
                end
                else if (bump_left || bump_right) begin
                    direction <= bump_left;
                    is_digging <= 0;
                end
                
                // Stop digging if we start falling next cycle
                if (!ground) begin
                    is_digging <= 0;
                end
            end
        end
    end

    assign walk_left  = (~state) & (~direction) & (~is_digging);
    assign walk_right = (~state) & direction & (~is_digging);
    assign aaah       = state;
    assign digging    = (~state) & is_digging;

endmodule