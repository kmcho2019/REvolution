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
    reg dir;        // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;
            dir <= 0;
        end else begin
            case (state)
                0: begin // WALK
                    if (!ground) begin
                        state <= 1; // Start falling
                    end else if (bump_left && !dir) begin
                        dir <= 1;  // Switch to right
                    end else if (bump_right && dir) begin
                        dir <= 0;  // Switch to left
                    end
                end
                1: begin // FALL
                    if (ground) begin
                        state <= 0; // Resume walking
                    end
                end
            endcase
        end
    end

    assign walk_left = (~state) & (~dir);
    assign walk_right = (~state) & dir;
    assign aaah = state;

endmodule