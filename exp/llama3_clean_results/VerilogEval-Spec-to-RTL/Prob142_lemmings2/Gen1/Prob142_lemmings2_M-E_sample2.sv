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
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    case(state)
        2'b00: // walking left
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling left
                end else if (bump_left) begin
                    next_state = 2'b01; // walking right
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end
            end
        2'b01: // walking right
            begin
                if (~ground) begin
                    next_state = 2'b11; // falling right
                end else if (bump_right) begin
                    next_state = 2'b00; // walking left
                end else if (bump_left) begin
                    // do nothing, keep walking right
                end
            end
        2'b10: // falling left
            begin
                if (ground) begin
                    next_state = 2'b00; // walking left
                end
            end
        2'b11: // falling right
            begin
                if (ground) begin
                    next_state = 2'b01; // walking right
                end
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        2'b01: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        2'b10: // falling left
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        2'b11: // falling right
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule