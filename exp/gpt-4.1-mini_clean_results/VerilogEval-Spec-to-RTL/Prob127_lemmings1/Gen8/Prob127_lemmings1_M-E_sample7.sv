module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot encoded states: state[1] = WALK_RIGHT, state[0] = WALK_LEFT
    reg [1:0] state, next_state;

    wire bump_any = bump_left | bump_right;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // WALK_LEFT state active
        else
            state <= next_state;
    end

    // Next state logic: toggle state if any bump; else hold current state
    always @(*) begin
        if (bump_any)
            next_state = {state[0], state[1]}; // Swap bits (toggle direction)
        else
            next_state = state;
    end

    // Outputs reflect the one-hot encoded states (Moore outputs)
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule