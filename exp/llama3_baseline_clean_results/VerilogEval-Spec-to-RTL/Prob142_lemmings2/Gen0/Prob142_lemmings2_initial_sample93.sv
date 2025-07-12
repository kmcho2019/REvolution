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

// State encoding: 2 bits
// bit 0: walking direction (0 for left, 1 for right)
// bit 1: falling state (0 for not falling, 1 for falling)
reg [1:0] state;
reg [1:0] nextState;

// Output logic
always @(state) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10, 2'b11: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

// Next state logic
always @(state, bump_left, bump_right, ground) begin
    case (state)
        2'b00: begin // walking left
            if (~ground) begin
                nextState = 2'b10; // falling, remember walking direction
            end else if (bump_left) begin
                nextState = 2'b01; // walk right
            end else if (bump_right) begin
                nextState = 2'b00; // still walk left
            end else begin
                nextState = 2'b00; // no change
            end
        end
        2'b01: begin // walking right
            if (~ground) begin
                nextState = 2'b11; // falling, remember walking direction
            end else if (bump_left) begin
                nextState = 2'b00; // walk left
            end else if (bump_right) begin
                nextState = 2'b01; // still walk right
            end else begin
                nextState = 2'b01; // no change
            end
        end
        2'b10: begin // falling, walked left before
            if (ground) begin
                nextState = 2'b00; // resume walking left
            end else begin
                nextState = 2'b10; // still falling
            end
        end
        2'b11: begin // falling, walked right before
            if (ground) begin
                nextState = 2'b01; // resume walking right
            end else begin
                nextState = 2'b11; // still falling
            end
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= nextState;
    end
end

endmodule