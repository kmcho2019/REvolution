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
    // Combined state and direction encoding
    // [1:0] - state (WALK=00, FALL=01, DIG=10)
    // [2]   - direction (0=left, 1=right)
    reg [2:0] state_reg;

    // State parameters
    parameter [1:0] WALK = 2'b00;
    parameter [1:0] FALL = 2'b01;
    parameter [1:0] DIG  = 2'b10;

    // Next state logic (combinational)
    wire [2:0] next_state;
    assign next_state = 
        areset ? {1'b0, WALK} :  // Reset to walk left
        (~ground & (state_reg[1:0] == WALK)) ? {state_reg[2], FALL} :  // Fall has highest priority
        (ground & dig & (state_reg[1:0] == WALK)) ? {state_reg[2], DIG} :  // Dig if on ground
        ((state_reg[1:0] == WALK) & ((bump_left & ~state_reg[2]) | (bump_right & state_reg[2]))) ? 
            {~state_reg[2], WALK} :  // Switch direction if bumped
        (state_reg[1:0] == FALL) & ground ? {state_reg[2], WALK} :  // Return to walk after fall
        (state_reg[1:0] == DIG) & ~ground ? {state_reg[2], FALL} :  // Fall after digging through
        state_reg;  // Default case

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= {1'b0, WALK};  // Start walking left
        end else begin
            state_reg <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state_reg[1:0] == WALK) & ~state_reg[2];
    assign walk_right = (state_reg[1:0] == WALK) & state_reg[2];
    assign aaah = (state_reg[1:0] == FALL);
    assign digging = (state_reg[1:0] == DIG);
endmodule