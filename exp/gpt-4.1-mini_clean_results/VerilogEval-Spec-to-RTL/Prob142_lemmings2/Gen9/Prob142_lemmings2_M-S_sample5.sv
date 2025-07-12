module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding: {falling, direction}
    // direction: 0=left, 1=right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    always @(*) begin
        // Combine bump signals: any bump flips direction when walking
        wire bump = bump_left | bump_right;

        if (state[1]) begin
            // Falling state
            if (ground)
                next_state = {1'b0, state[0]}; // back to walking same direction
            else
                next_state = state; // keep falling
        end else begin
            // Walking state
            if (!ground)
                next_state = {1'b1, state[0]}; // start falling, keep direction
            else if (bump)
                next_state = {1'b0, ~state[0]}; // flip direction
            else
                next_state = state; // no change
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs for Moore FSM
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule