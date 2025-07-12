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

    // Hierarchical state encoding
    // state[2] = !ground (1=falling)
    // state[1] = digging (1=digging)
    // state[0] = direction (0=left, 1=right)
    reg [2:0] state;

    // Registered outputs
    reg r_walk_left, r_walk_right, r_aaah, r_digging;

    // Next state and direction logic
    wire next_direction;
    wire [2:0] next_state;

    // Direction update logic (power-gated)
    assign next_direction = (state[2]) ? state[0] : // Maintain direction while falling
                          (dig && ground && !state[2]) ? state[0] : // Maintain while digging
                          (bump_right && state[0]) ? 1'b0 : // Right bump when going right
                          (bump_left && !state[0]) ? 1'b1 : // Left bump when going left
                          state[0]; // Default case

    // Next state computation (parallel case style)
    assign next_state = areset ? 3'b000 : // Reset to walk left
                      (!ground) ? {1'b1, state[1:0]} : // Fall takes highest priority
                      (dig && ground && !state[2]) ? {1'b0, 1'b1, state[0]} : // Dig if possible
                      {1'b0, 1'b0, next_direction}; // Otherwise walk with new direction

    // State transition
    always @(posedge clk) begin
        state <= next_state;
        
        // Output pipeline registers
        r_walk_left <= (next_state[2:1] == 2'b00) && !next_state[0];
        r_walk_right <= (next_state[2:1] == 2'b00) && next_state[0];
        r_aaah <= next_state[2];
        r_digging <= next_state[1] && !next_state[2];
    end

    // Output assignments
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;

endmodule