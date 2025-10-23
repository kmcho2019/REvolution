module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Combined state encoding [action_state, direction]
    parameter WALK_LEFT  = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter DIG_LEFT   = 3'b010;
    parameter DIG_RIGHT  = 3'b011;
    parameter FALL_LEFT  = 3'b100;
    parameter FALL_RIGHT = 3'b101;
    parameter SPLAT      = 3'b110;
    reg [2:0] state;

    // Fall duration counter
    reg [4:0] fall_cycles;

    // Next state logic (combinational)
    wire [2:0] next_state;
    assign next_state = 
        (state == SPLAT) ? SPLAT :  // Once splat, forever splat
        (!ground && (state == WALK_LEFT || state == WALK_RIGHT || 
                    state == DIG_LEFT || state == DIG_RIGHT)) ? 
            (state[1] ? {1'b1, 1'b0, state[0]} : {1'b1, 1'b0, state[0]}) : // Start falling, keep direction
        (state == FALL_LEFT || state == FALL_RIGHT) ?
            (ground ? 
                (fall_cycles >= 20 ? SPLAT : 
                    (state == FALL_LEFT ? WALK_LEFT : WALK_RIGHT)) : 
                state) : // Continue falling
        (dig && ground && (state == WALK_LEFT || state == WALK_RIGHT)) ?
            {1'b0, 1'b1, state[0]} : // Start digging, keep direction
        ((bump_left || bump_right) && (state == WALK_LEFT || state == WALK_RIGHT)) ?
            ((bump_left && !bump_right) ? WALK_RIGHT : 
             (bump_right && !bump_left) ? WALK_LEFT : 
             state[0] ? WALK_LEFT : WALK_RIGHT) : // Switch direction (even if both bumps)
        state; // Default: stay in current state

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            // Update fall counter
            if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
                fall_cycles <= (state == FALL_LEFT || state == FALL_RIGHT) ? 
                               fall_cycles + 1 : 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule