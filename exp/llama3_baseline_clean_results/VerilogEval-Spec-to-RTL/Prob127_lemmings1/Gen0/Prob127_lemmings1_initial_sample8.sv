module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the states
localparam STATE_WALK_LEFT = 1'b0;
localparam STATE_WALK_RIGHT = 1'b1;

// Declare the state variable
reg state;

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_WALK_LEFT;
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state;
        end else begin
            state <= state;
        end
    end
end

// Output logic
always @(*) begin
    if (state == STATE_WALK_LEFT) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end
end

endmodule