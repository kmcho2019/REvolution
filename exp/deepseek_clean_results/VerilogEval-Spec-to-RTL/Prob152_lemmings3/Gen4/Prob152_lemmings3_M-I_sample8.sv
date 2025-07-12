module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (2 bits)
    // [1:0] = {falling/digging, direction}
    // 00: Walking left
    // 01: Walking right
    // 10: Falling (direction preserved in bit 0)
    // 11: Digging (direction preserved in bit 0)
    reg [1:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Reset to walking left
        end else begin
            case (state)
                2'b00, 2'b01: begin // Walking states
                    if (~ground) begin
                        state <= {1'b1, state[0]}; // Fall, keep direction
                    end else if (dig) begin
                        state <= 2'b11; // Start digging
                    end else if (bump_left ^ bump_right) begin // Single bump
                        state <= {1'b0, bump_left};
                    end else if (bump_left & bump_right) begin // Both bumps
                        state <= {1'b0, ~state[0]};
                    end
                end
                2'b10: begin // Falling
                    if (ground) begin
                        state <= {1'b0, state[0]}; // Resume walking
                    end
                end
                2'b11: begin // Digging
                    if (~ground) begin
                        state <= 2'b10; // Start falling
                    end
                end
            endcase
        end
    end

    // Optimized output logic
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1] & ~state[0]; // Falling
    assign digging = state[1] & state[0]; // Digging

endmodule