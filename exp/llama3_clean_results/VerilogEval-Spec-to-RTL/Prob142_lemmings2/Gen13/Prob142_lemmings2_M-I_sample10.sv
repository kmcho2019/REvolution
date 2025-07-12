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

// Using one-hot encoding for states to potentially improve timing and area
reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)
reg [1:0] next_state;

// Simplifying combinational logic
always @(*) begin
    next_state = state;

    case(state)
        2'b00: // walking left
            if (~ground) begin
                next_state = 2'b10; // falling left
            end else if (bump_left) begin
                next_state = 2'b01; // walking right
            end else if (bump_right) begin
                // No change, keep walking left
            end
        2'b01: // walking right
            if (~ground) begin
                next_state = 2'b11; // falling right
            end else if (bump_right) begin
                next_state = 2'b00; // walking left
            end else if (bump_left) begin
                // No change, keep walking right
            end
        2'b10: // falling left
            if (ground) begin
                next_state = 2'b00; // walking left
            end
        2'b11: // falling right
            if (ground) begin
                next_state = 2'b01; // walking right
            end
    endcase
end

// Sequential logic remains the same
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic remains the same
assign walk_left = (state == 2'b00)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10 || state == 2'b11)? 1'b1 : 1'b0;

endmodule