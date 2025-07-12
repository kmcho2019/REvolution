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

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // Start in WALK state
            direction <= 0;     // Start walking left
        end
        else begin
            case (state)
                0: begin        // WALK state
                    if (!ground)
                        state <= 1;  // Transition to FALL
                    else if ((!direction && bump_left) || (direction && bump_right))
                        direction <= ~direction;  // Change direction if bumped
                end
                1: begin        // FALL state
                    if (ground)
                        state <= 0;  // Return to WALK when ground reappears
                end
            endcase
        end
    end

    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule