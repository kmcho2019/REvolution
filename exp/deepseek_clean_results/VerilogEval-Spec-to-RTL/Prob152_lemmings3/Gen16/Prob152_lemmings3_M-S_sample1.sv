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

    // Combined state and direction encoding:
    // [1]: 0=walk/dig, 1=fall
    // [0]: 0=left, 1=right (valid in walk/dig states)
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Walk left
        end else begin
            case (state[1])
                0: begin // Walking or digging
                    if (~ground) begin
                        state <= {1'b1, state[0]}; // Fall, keep direction
                    end else if (dig && state != 2'b11) begin
                        state <= 2'b11; // Dig right (direction preserved)
                    end else if (state != 2'b11) begin // Only change direction when walking
                        if (bump_left) begin
                            state <= 2'b01; // Walk right
                        end else if (bump_right) begin
                            state <= 2'b00; // Walk left
                        end
                    end
                end
                1: begin // Falling
                    if (ground) begin
                        state <= {1'b0, state[0]}; // Resume walking with saved direction
                    end
                end
            endcase
        end
    end

    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = state[1];
    assign digging    = (state == 2'b11);

endmodule