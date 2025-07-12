module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states and walking directions using a single 2-bit variable
reg [1:0] state_walk;

// Sequential logic with synchronous reset
always_ff @(posedge clk) begin
    if (areset) begin
        state_walk <= 2'b01; // Initialize to walking left
    end else begin
        // Combinational logic for next state
        if (!ground) begin
            // If not on ground, always fall
            state_walk <= 2'b00; // Falling
        end else if (dig) begin
            // If on ground and digging, start digging
            state_walk <= 2'b10; // Digging
        end else if (bump_left || bump_right) begin
            // If bumped, switch walking direction
            state_walk[0] <= ~state_walk[0]; // Toggle walking direction
        end
    end
end

// Output logic
assign walk_left = (state_walk[1] && ~state_walk[0]);
assign walk_right = (state_walk[1] && state_walk[0]);
assign aaah = (~state_walk[1]);
assign digging = (state_walk[1] && state_walk[0]);

endmodule