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

    // State encoding:
    // bit1 = falling (1) or walking (0)
    // bit0 = direction: 0 = left, 1 = right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        if (state[1] == 1'b0) begin // Walking states
            if (!ground) begin
                // Start falling, preserve direction
                next_state = {1'b1, state[0]};
            end else if (bump_left | bump_right) begin
                // Flip direction on any bump while walking and on ground
                next_state = {1'b0, ~state[0]};
            end else begin
                // Hold current walking state
                next_state = state;
            end
        end else begin // Falling states
            if (ground) begin
                // Land and resume walking same direction
                next_state = {1'b0, state[0]};
            end else begin
                // Continue falling same direction
                next_state = state;
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // Reset to walking left
        else
            state <= next_state;
    end

    // Outputs decode directly from state bits (Moore FSM)
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule