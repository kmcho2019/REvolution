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

    // State encoding: 0=WALK, 1=FALL
    reg state;
    // Direction: 0=left, 1=right
    reg direction;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;         // Start walking left
            direction <= 0;
        end
        else case (state)
            0: begin           // WALK state
                if (!ground) begin
                    state <= 1; // Start falling
                end
                else if (bump_left && !direction) begin
                    direction <= 1; // Switch to right
                end
                else if (bump_right && direction) begin
                    direction <= 0; // Switch to left
                end
            end
            1: begin           // FALL state
                if (ground) begin
                    state <= 0; // Return to walking
                end
            end
        endcase
    end

    // Output assignments
    assign walk_left = (~state) & (~direction);
    assign walk_right = (~state) & direction;
    assign aaah = state;

endmodule