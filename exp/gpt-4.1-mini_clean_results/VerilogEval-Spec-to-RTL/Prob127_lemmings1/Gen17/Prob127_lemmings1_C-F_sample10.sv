module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;
    wire [1:0] bumps = {bump_left, bump_right};

    // Combinational next state logic with explicit case handling (no default)
    always @(*) begin
        case (bumps)
            2'b00: next_state = state;         // no bumps, hold current state
            2'b01: next_state = WALK_LEFT;     // bump right only -> walk left
            2'b10: next_state = WALK_RIGHT;    // bump left only -> walk right
            2'b11: next_state = ~state;        // bump both sides -> toggle direction
        endcase
    end

    // Sequential state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs derived from current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule