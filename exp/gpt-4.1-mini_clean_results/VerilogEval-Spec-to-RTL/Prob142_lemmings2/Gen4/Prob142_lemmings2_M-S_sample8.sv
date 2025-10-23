module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding: 2'b00 = walk left, 2'b01 = walk right, 2'b10 = falling
    reg [1:0] state;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Walk left
        end else begin
            case(state)
                2'b00: begin // Walk left
                    if (!ground) begin
                        state <= 2'b10; // Start falling
                    end else if (bump_left && bump_right) begin
                        state <= 2'b01; // Both bumps: flip direction to right
                    end else if (bump_left) begin
                        state <= 2'b01; // Bump left: walk right
                    end else if (bump_right) begin
                        // Already walking left, no change needed if bump_right on left walk means walk left again,
                        // But per problem: bump_right means walk left, so remain.
                        // So stay in 2'b00
                        state <= 2'b00;
                    end else begin
                        state <= 2'b00; // No bump: stay walking left
                    end
                end
                2'b01: begin // Walk right
                    if (!ground) begin
                        state <= 2'b10; // Start falling
                    end else if (bump_left && bump_right) begin
                        state <= 2'b00; // Both bumps: flip direction to left
                    end else if (bump_left) begin
                        // Bump left: walk right, already walking right, stay
                        state <= 2'b01;
                    end else if (bump_right) begin
                        state <= 2'b00; // Bump right: walk left
                    end else begin
                        state <= 2'b01; // No bump: stay walking right
                    end
                end
                2'b10: begin // Falling
                    if (ground) begin
                        // Resume walking in previous direction (stored in lower bit of state)
                        // Recover walking state using bit0
                        if (state[0])
                            state <= 2'b01; // walk right
                        else
                            state <= 2'b00; // walk left
                    end else begin
                        state <= 2'b10; // Remain falling
                    end
                end
                default: state <= 2'b00; // Safe default to walk left
            endcase
        end
    end

    // Outputs - Moore
    assign aaah       = (state == 2'b10);
    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);

endmodule