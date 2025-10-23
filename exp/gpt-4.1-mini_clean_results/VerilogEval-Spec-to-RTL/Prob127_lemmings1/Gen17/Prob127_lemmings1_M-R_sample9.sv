module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot encoding for states
    localparam WALK_LEFT  = 2'b01;
    localparam WALK_RIGHT = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT; // safe default
        endcase
    end

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore FSM): one-hot states directly encode outputs
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule