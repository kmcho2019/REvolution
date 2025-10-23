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
            state <= 0;
            direction <= 0;
        end else begin
            if (state) begin
                if (ground) state <= 0;  // Stop falling when ground returns
            end else begin
                if (!ground) begin
                    state <= 1;         // Start falling
                end else if (bump_left && !direction) begin
                    direction <= 1;     // Switch to right
                end else if (bump_right && direction) begin
                    direction <= 0;    // Switch to left
                end
            end
        end
    end

    assign walk_left = (~state) & (~direction);
    assign walk_right = (~state) & direction;
    assign aaah = state;

endmodule