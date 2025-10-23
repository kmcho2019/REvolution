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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)
reg [1:0] next_state;
reg direction; // 1 bit to represent the direction (0: left, 1: right)

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;
    if (~ground) begin
        next_state = 2'b10; // falling
    end else if (bump_left && ~direction) begin
        next_state = 2'b01; // walking right
    end else if (bump_right && direction) begin
        next_state = 2'b00; // walking left
    end
end

// Combinational logic to determine the direction
always @(*) begin
    if (state == 2'b10) begin // falling
        direction = (next_state == 2'b00)? 0 : 1; // keep previous direction
    end else if (next_state == 2'b01) begin // walking right
        direction = 1;
    end else if (next_state == 2'b00) begin // walking left
        direction = 0;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        direction <= 0; // reset to left
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state != 2'b10 && ~direction)? 1'b1 : 1'b0;
assign walk_right = (state != 2'b10 && direction)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10)? 1'b1 : 1'b0;

endmodule