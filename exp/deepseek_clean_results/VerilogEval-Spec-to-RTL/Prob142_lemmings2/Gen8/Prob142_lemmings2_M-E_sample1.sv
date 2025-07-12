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

    // Combined state encoding: {falling, direction}
    // [0] = direction (0:left, 1:right)
    // [1] = falling (0:walking, 1:falling)
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            2'b00: begin  // Walking left
                if (!ground) next_state = 2'b10;  // Start falling
                else if (bump_left) next_state = 2'b01;  // Switch to right
                else next_state = 2'b00;  // Keep walking left
            end
            2'b01: begin  // Walking right
                if (!ground) next_state = 2'b11;  // Start falling
                else if (bump_right) next_state = 2'b00;  // Switch to left
                else next_state = 2'b01;  // Keep walking right
            end
            2'b10: begin  // Falling left
                if (ground) next_state = 2'b00;  // Resume walking left
                else next_state = 2'b10;  // Keep falling
            end
            2'b11: begin  // Falling right
                if (ground) next_state = 2'b01;  // Resume walking right
                else next_state = 2'b11;  // Keep falling
            end
            default: next_state = 2'b00;  // Shouldn't happen
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) state <= 2'b00;  // Reset to walk left
        else state <= next_state;
    end

    // Output assignments
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1];  // Falling bit

endmodule