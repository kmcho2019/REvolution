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
    wire clk_gated = clk & (~state | ground);  // Clock gating during FALL

    // State update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK state
        end
        else begin
            if (state) begin    // FALL state
                if (ground) state <= 0;
            end
            else begin          // WALK state
                if (!ground) state <= 1;
            end
        end
    end

    // Direction update logic with clock gating
    always @(posedge clk_gated, posedge areset) begin
        if (areset) begin
            direction <= 0;     // Left direction
        end
        else if (~state) begin  // Only update direction when walking
            if ((!direction && bump_left) || (direction && bump_right))
                direction <= ~direction;
        end
    end

    // Output logic
    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule