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

reg [1:0] state; // 2-bit state variable (00: left, 01: right, 10: falling)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    case (state)
        2'b00: // left
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_right) begin
                next_state = 2'b01; // right
            end
        2'b01: // right
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_left) begin
                next_state = 2'b00; // left
            end
        2'b10: // falling
            if (ground) begin
                next_state = (bump_right) ? 2'b01 : 2'b00; // resume walking
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to left
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule