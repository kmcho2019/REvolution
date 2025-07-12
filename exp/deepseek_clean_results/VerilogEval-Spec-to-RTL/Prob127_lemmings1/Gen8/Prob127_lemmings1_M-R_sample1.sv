module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;

    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            LEFT:  next_state = bump_left ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT : RIGHT;
            default: next_state = LEFT;
        endcase
    end

    // Sequential state storage
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule