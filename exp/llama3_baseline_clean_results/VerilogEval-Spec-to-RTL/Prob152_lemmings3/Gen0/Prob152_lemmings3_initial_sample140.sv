module TopModule(
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

// State encoding: WALK_LEFT (00), WALK_RIGHT (01), FALLING (10), DIGGING (11)
reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                nextState = 2'b10; // FALLING
            end else if (dig) begin
                nextState = 2'b11; // DIGGING
            end else if (bump_left) begin
                nextState = 2'b01; // WALK_RIGHT
            end else begin
                nextState = 2'b00; // WALK_LEFT
            end
        end
        2'b01: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                nextState = 2'b10; // FALLING
            end else if (dig) begin
                nextState = 2'b11; // DIGGING
            end else if (bump_right) begin
                nextState = 2'b00; // WALK_LEFT
            end else begin
                nextState = 2'b01; // WALK_RIGHT
            end
        end
        2'b10: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground) begin
                if (bump_left || bump_right) begin
                    nextState = bump_left ? 2'b01 : 2'b00; // Switch direction
                end else if (dig) begin
                    nextState = 2'b11; // DIGGING
                end else if (state == 2'b10) begin // Resuming walking
                    nextState = bump_left ? 2'b01 : 2'b00; // Default to WALK_LEFT
                end else begin
                    nextState = state; // Previous state (WALK_LEFT or WALK_RIGHT)
                end
            end else begin
                nextState = 2'b10; // FALLING
            end
        end
        2'b11: begin // DIGGING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (~ground) begin
                nextState = 2'b10; // FALLING
            end else begin
                nextState = 2'b11; // DIGGING
            end
        end
        default: begin
            nextState = 2'b00; // WALK_LEFT (default state)
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT (initial state)
    end else begin
        state <= nextState;
    end
end

endmodule