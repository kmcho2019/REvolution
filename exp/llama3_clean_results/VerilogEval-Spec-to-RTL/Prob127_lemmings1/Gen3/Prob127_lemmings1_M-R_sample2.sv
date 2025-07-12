module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
parameter WALK_LEFT = 0;
parameter WALK_RIGHT = 1;

// Internal state register
reg state;

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);

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