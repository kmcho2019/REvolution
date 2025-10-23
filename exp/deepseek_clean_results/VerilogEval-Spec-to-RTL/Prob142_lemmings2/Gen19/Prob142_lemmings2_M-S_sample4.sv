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

    // States: LEFT, RIGHT, FALL
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // LEFT state
        end
        else begin
            case (state)
                2'b00: begin  // LEFT
                    if (!ground)
                        state <= 2'b10;  // FALL
                    else if (bump_left)
                        state <= 2'b01;  // RIGHT
                end
                2'b01: begin  // RIGHT
                    if (!ground)
                        state <= 2'b10;  // FALL
                    else if (bump_right)
                        state <= 2'b00;  // LEFT
                end
                2'b10: begin  // FALL
                    if (ground)
                        state <= state - 2'b10;  // Return to previous walking state
                end
            endcase
        end
    end

    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = (state == 2'b10);

endmodule