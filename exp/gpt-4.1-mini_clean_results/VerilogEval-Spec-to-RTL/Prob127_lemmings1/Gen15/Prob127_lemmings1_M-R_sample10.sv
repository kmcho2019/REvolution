module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case ({bump_left, bump_right})
            2'b10: next_state = WALK_RIGHT;       // bumped left -> walk right
            2'b01: next_state = WALK_LEFT;        // bumped right -> walk left
            2'b11: next_state = ~state;            // both bumps -> toggle
            default: next_state = state;           // no bump -> hold state
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs from state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule