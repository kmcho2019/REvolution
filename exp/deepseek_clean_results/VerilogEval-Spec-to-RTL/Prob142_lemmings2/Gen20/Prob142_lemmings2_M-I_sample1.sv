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
    wire walking;   // Common term for not falling

    assign walking = ~state;

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
                end else if ((bump_left && !direction) || (bump_right && direction)) begin
                    direction <= ~direction;  // Toggle direction
                end
            end
        end
    end

    assign walk_left = walking & ~direction;
    assign walk_right = walking & direction;
    assign aaah = state;

endmodule