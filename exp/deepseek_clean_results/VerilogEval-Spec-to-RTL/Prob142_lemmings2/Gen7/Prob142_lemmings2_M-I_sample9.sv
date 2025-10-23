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

    reg state;      // 0=WALK, 1=FALL
    reg direction;   // 0=left, 1=right

    // Combined state and direction update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK state
            direction <= 0;     // Left direction
        end
        else begin
            // State transition
            if (state) begin    // FALL state
                if (ground) state <= 0;
            end
            else begin          // WALK state
                if (!ground) state <= 1;
                else begin
                    // Direction update only when walking and on ground
                    if ((!direction && bump_left) || (direction && bump_right))
                        direction <= ~direction;
                end
            end
        end
    end

    // Output logic
    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule