module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;
    reg next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore machine: outputs depend only on state)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule