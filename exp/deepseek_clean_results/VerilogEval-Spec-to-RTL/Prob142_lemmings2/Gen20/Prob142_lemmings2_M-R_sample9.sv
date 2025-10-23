module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State parameters
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT  = 2'b10;
    parameter FALL_RIGHT = 2'b11;

    reg [1:0] state;
    wire [1:0] next_state;

    // Next state logic
    assign next_state = 
        areset ? WALK_LEFT :
        state[1] ? // Falling state
            (ground ? {1'b0, state[0]} : state) :
        // Walking state
            (~ground ? {1'b1, state[0]} :
             ((state == WALK_LEFT && bump_left) || 
              (state == WALK_RIGHT && bump_right)) ? 
                 {state[1], ~state[0]} : state);

    // State register
    always @(posedge clk, posedge areset) begin
        state <= next_state;
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1];

endmodule