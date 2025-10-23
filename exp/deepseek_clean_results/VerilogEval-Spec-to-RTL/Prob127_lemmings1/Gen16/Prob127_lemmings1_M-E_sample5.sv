module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    
    // Current and next state registers
    reg state, next_state;
    reg out_left, out_right;
    
    // Predictive state computation (combinational)
    always @* begin
        case (state)
            LEFT: next_state = bump_left ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT : RIGHT;
            default: next_state = LEFT;
        endcase
    end
    
    // Dual-edge triggered state machine
    always @(posedge clk or negedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            out_left <= 1'b1;
            out_right <= 1'b0;
        end else begin
            state <= next_state;
            // Registered outputs for glitch prevention
            out_left <= (next_state == LEFT);
            out_right <= (next_state == RIGHT);
        end
    end
    
    assign walk_left = out_left;
    assign walk_right = out_right;

endmodule