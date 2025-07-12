module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

// Assign default values to outputs
assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

always @(*) begin
    case (state)
        2'b00: // Walking left
            begin
                if (!ground) begin
                    nextState = 2'b10; // Falling
                end else if (bump_left) begin
                    nextState = 2'b01; // Walking right
                end else if (bump_right) begin
                    nextState = 2'b00; // Still walking left
                end else begin
                    nextState = 2'b00; // No change
                end
            end
        2'b01: // Walking right
            begin
                if (!ground) begin
                    nextState = 2'b10; // Falling
                end else if (bump_right) begin
                    nextState = 2'b00; // Walking left
                end else if (bump_left) begin
                    nextState = 2'b01; // Still walking right
                end else begin
                    nextState = 2'b01; // No change
                end
            end
        2'b10: // Falling
            begin
                if (ground) begin
                    // Resume walking in the same direction as before the fall
                    if (bump_left) begin
                        nextState = 2'b01;
                    end else if (bump_right) begin
                        nextState = 2'b00;
                    end else if (nextState == 2'b00) begin
                        nextState = 2'b00;
                    end else if (nextState == 2'b01) begin
                        nextState = 2'b01;
                    end else begin
                        nextState = 2'b00; // Default to walking left
                    end
                end else begin
                    nextState = 2'b10; // Still falling
                end
            end
        default: // Idle (after falling)
            begin
                if (ground) begin
                    // Resume walking in the same direction as before the fall
                    if (bump_left) begin
                        nextState = 2'b01;
                    end else if (bump_right) begin
                        nextState = 2'b00;
                    end else if (nextState == 2'b00) begin
                        nextState = 2'b00;
                    end else if (nextState == 2'b01) begin
                        nextState = 2'b01;
                    end else begin
                        nextState = 2'b00; // Default to walking left
                    end
                end else begin
                    nextState = 2'b10; // Still idle
                end
            end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= nextState;
    end
end

endmodule