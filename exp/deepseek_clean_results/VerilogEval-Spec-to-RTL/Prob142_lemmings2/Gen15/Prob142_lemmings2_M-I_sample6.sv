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

    // State encoding: [1] = falling, [0] = direction (0=left, 1=right)
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Reset to walk left
        end
        else begin
            case (state)
                2'b00: // Walk left
                    if (!ground) state <= 2'b10; // Start falling left
                    else if (bump_left) state <= 2'b01; // Switch to right
                
                2'b01: // Walk right
                    if (!ground) state <= 2'b11; // Start falling right
                    else if (bump_right) state <= 2'b00; // Switch to left
                
                2'b10, 2'b11: // Falling left or right
                    if (ground) state <= {1'b0, state[0]}; // Resume walking
            endcase
        end
    end

    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1];

endmodule