module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;

// Declare the current state signal
reg [0:0] current_state;

// Initialize the current state to walking left
initial current_state = WALK_LEFT;

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to walking left
        current_state <= WALK_LEFT;
    end else begin
        // Switch states if bumped
        if (bump_left) begin
            current_state <= WALK_RIGHT;
        end else if (bump_right) begin
            current_state <= WALK_LEFT;
        end else if (bump_left && bump_right) begin
            // If bumped on both sides, still switch directions
            if (current_state == WALK_LEFT) begin
                current_state <= WALK_RIGHT;
            end else begin
                current_state <= WALK_LEFT;
            end
        end
    end
end

// Generate the walk_left and walk_right outputs based on the current state
assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule