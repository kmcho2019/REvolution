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
reg [1:0] next_state;

// Outputs are determined solely by the current state
assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;

    case (state)
        2'b00: begin // Walking left
            if (!ground) begin
                next_state = 2'b10; // Transition to falling
            end else if (bump_left) begin
                next_state = 2'b01; // Transition to walking right
            end
        end
        2'b01: begin // Walking right
            if (!ground) begin
                next_state = 2'b10; // Transition to falling
            end else if (bump_right) begin
                next_state = 2'b00; // Transition to walking left
            end
        end
        2'b10: begin // Falling
            if (ground) begin
                // Resume walking in the same direction as before the fall
                if (bump_left && bump_right) begin
                    // If bumped on both sides at the same time, switch direction
                    if (next_state == 2'b00) begin
                        next_state = 2'b01;
                    end else begin
                        next_state = 2'b00;
                    end
                end else if (bump_left) begin
                    next_state = 2'b01; // Transition to walking right
                end else if (bump_right) begin
                    next_state = 2'b00; // Transition to walking left
                end else if (state == 2'b00) begin
                    next_state = 2'b00; // Resume walking left
                end else if (state == 2'b01) begin
                    next_state = 2'b01; // Resume walking right
                end
            end
        end
    endcase
end

endmodule