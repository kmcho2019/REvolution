module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)

// Combinational logic to determine the next state
always @(state or bump_left or bump_right or ground) begin
    if (~ground) begin
        // Falling state, no change in direction due to bumps
        case (state)
            2'b00, 2'b10: walk_left = 1'b0; walk_right = 1'b0; aaah = 1'b1;
            2'b01, 2'b11: walk_left = 1'b0; walk_right = 1'b0; aaah = 1'b1;
        endcase
    end else if (ground && (state == 2'b10 || state == 2'b11)) begin
        // Resuming walking after falling, maintain previous direction
        case (state)
            2'b10: walk_left = 1'b1; walk_right = 1'b0; aaah = 1'b0;
            2'b11: walk_left = 1'b0; walk_right = 1'b1; aaah = 1'b0;
        endcase
    end else begin
        // Walking states, change direction based on bumps
        case (state)
            2'b00: if (bump_left) begin walk_left = 1'b0; walk_right = 1'b1; aaah = 1'b0; end else begin walk_left = 1'b1; walk_right = 1'b0; aaah = 1'b0; end
            2'b01: if (bump_right) begin walk_left = 1'b1; walk_right = 1'b0; aaah = 1'b0; end else begin walk_left = 1'b0; walk_right = 1'b1; aaah = 1'b0; end
        endcase
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
        walk_left <= 1'b1; walk_right <= 1'b0; aaah <= 1'b0;
    end else begin
        if (~ground) begin
            // Update state to falling when ground disappears
            case (state)
                2'b00: state <= 2'b10;
                2'b01: state <= 2'b11;
                default: state <= state;
            endcase
        end else if (ground && (state == 2'b10 || state == 2'b11)) begin
            // Update state back to walking when ground reappears
            case (state)
                2'b10: state <= 2'b00;
                2'b11: state <= 2'b01;
                default: state <= state;
            endcase
        end else begin
            // Update state based on bumps while walking
            case (state)
                2'b00: if (bump_left) state <= 2'b01;
                2'b01: if (bump_right) state <= 2'b00;
                default: state <= state;
            endcase
        end
    end
end

endmodule