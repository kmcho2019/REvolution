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
    reg direction;  // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // WALK state
            direction <= 0;     // Left direction
        end
        else begin
            // State transition
            if (state) begin    // FALL state
                if (ground) state <= 0;
                // Direction remains unchanged during fall
            end
            else begin          // WALK state
                if (!ground) begin
                    state <= 1; // Transition to FALL
                end
                else if ((!direction && bump_left) || 
                        (direction && bump_right)) begin
                    direction <= ~direction; // Toggle direction
                end
            end
        end
    end

    // Output logic - Moore style
    assign walk_left = (~state) & (~direction);
    assign walk_right = (~state) & direction;
    assign aaah = state;

endmodule