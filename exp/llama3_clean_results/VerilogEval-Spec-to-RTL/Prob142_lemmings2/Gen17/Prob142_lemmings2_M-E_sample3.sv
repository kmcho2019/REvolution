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

// Top-level state machine
reg [1:0] top_state; // 00: walking, 01: falling, 10: transitioning
reg [1:0] next_top_state;

// Sub-state machine
reg direction_change_pending;
reg direction_change_done;
reg [1:0] direction; // 00: left, 01: right

// Combinational logic for top-level state machine
always @(*) begin
    next_top_state = top_state;

    if (~ground) begin
        next_top_state = 2'b01; // falling
    end else if (ground && (top_state == 2'b01)) begin
        next_top_state = 2'b00; // walking
    end else if ((bump_left || bump_right) && (top_state == 2'b00)) begin
        next_top_state = 2'b10; // transitioning
    end
end

// Combinational logic for sub-state machine
always @(*) begin
    direction_change_pending = 1'b0;
    direction_change_done = 1'b0;

    if ((bump_left && direction == 2'b00) || (bump_right && direction == 2'b01)) begin
        direction_change_pending = 1'b1;
    end else if ((bump_left && direction == 2'b01) || (bump_right && direction == 2'b00)) begin
        direction_change_done = 1'b1;
    end
end

// Sequential logic for top-level state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= 2'b00; // reset to walking
        direction <= 2'b00; // reset to left
    end else begin
        top_state <= next_top_state;

        if (next_top_state == 2'b10) begin
            if (direction == 2'b00) begin
                direction <= 2'b01; // change to right
            end else begin
                direction <= 2'b00; // change to left
            end
        end
    end
end

// Output logic
assign walk_left = (top_state == 2'b00 && direction == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (top_state == 2'b00 && direction == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (top_state == 2'b01) ? 1'b1 : 1'b0;

endmodule