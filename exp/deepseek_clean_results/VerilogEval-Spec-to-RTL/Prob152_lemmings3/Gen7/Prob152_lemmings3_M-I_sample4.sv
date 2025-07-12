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
    // Combined state encoding [state(1:0), direction(0)]
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [2:0] state; // {state[1:0], direction}

    // Combinational next state logic
    wire [2:0] next_state;
    assign next_state = (state[2]) ? {state[1:0], 1'b0} : // Initialize to avoid latch
        (state[1:0] == WALK) ? 
            (~ground ? {FALL, state[2]} : 
             dig ? {DIG, state[2]} : 
             {WALK, (bump_left && ~state[2]) ? 1'b1 : 
                   (bump_right && state[2]) ? 1'b0 : 
                   state[2]}) :
        (state[1:0] == FALL) ? 
            (ground ? {WALK, state[2]} : {FALL, state[2]}) :
        /* DIG */ (~ground ? {FALL, state[2]} : {DIG, state[2]});

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {WALK, 1'b0}; // Start walking left
        end else begin
            state <= next_state;
        end
    end

    // Optimized output logic
    wire is_walking = (state[1:0] == WALK);
    wire is_left = ~state[2];
    assign walk_left  = is_walking & is_left;
    assign walk_right = is_walking & ~is_left;
    assign aaah       = (state[1:0] == FALL);
    assign digging    = (state[1:0] == DIG);
    
endmodule