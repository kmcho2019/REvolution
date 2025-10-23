module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the states
parameter WALK_LEFT = 0;
parameter WALK_RIGHT = 1;

// Internal state register
reg state;

// Output logic
always @(*) begin
    if (state == WALK_LEFT) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end
end

// Sequential logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state;
        end else if (bump_left) begin
            state <= WALK_RIGHT;
        end else if (bump_right) begin
            state <= WALK_LEFT;
        end 
    end
end

endmodule