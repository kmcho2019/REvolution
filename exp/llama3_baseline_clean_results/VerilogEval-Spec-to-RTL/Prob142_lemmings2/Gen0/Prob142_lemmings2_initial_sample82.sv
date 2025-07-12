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

// State encoding: 2'b00 - walking left, 2'b01 - walking right, 2'b10 - falling
reg [1:0] state, next_state;

// Output logic
always @(state) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        2'b00: begin
            if (~ground) begin
                next_state = 2'b10;
            end else if (bump_left) begin
                next_state = 2'b01;
            end else if (bump_right) begin
                // No change in state
            end
        end
        2'b01: begin
            if (~ground) begin
                next_state = 2'b10;
            end else if (bump_left) begin
                // No change in state
            end else if (bump_right) begin
                next_state = 2'b00;
            end
        end
        2'b10: begin
            if (ground) begin
                // Resume walking in original direction
                if (bump_left || bump_right) begin
                    // No change in state, ignore bumps during ground reappearing
                end else if (state == 2'b00) begin
                    next_state = 2'b00;
                end else if (state == 2'b01) begin
                    next_state = 2'b01;
                end
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule