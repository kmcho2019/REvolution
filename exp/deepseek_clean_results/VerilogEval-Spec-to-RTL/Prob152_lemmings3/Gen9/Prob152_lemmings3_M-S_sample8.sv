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

    // State encoding: [1:0]
    // 00: WALK_LEFT
    // 01: WALK_RIGHT
    // 10: FALLING
    // 11: DIGGING
    reg [1:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Start walking left
        end else begin
            case (state)
                2'b00, 2'b01: begin // Walking states
                    if (~ground) begin
                        state <= 2'b10; // Fall
                    end else if (dig) begin
                        state <= 2'b11; // Dig
                    end else if ((state[0] ? bump_left : bump_right) || 
                                (bump_left && bump_right)) begin
                        state <= {~state[0], 1'b0}; // Switch direction
                    end
                end
                2'b10: begin // Falling
                    if (ground) begin
                        state <= {state[1:1], 1'b0}; // Return to walking
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

    // Output logic
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = (state == 2'b10);
    assign digging = (state == 2'b11);

endmodule