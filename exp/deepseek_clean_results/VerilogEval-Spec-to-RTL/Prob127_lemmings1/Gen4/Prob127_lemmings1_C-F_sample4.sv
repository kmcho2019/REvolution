module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding (1-bit for minimal area)
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;

    // Combined state transition and register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT:  state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
            endcase
        end
    end

    // Continuous output assignments (Moore machine outputs)
    assign walk_left = ~state;  // LEFT when state is 0
    assign walk_right = state;  // RIGHT when state is 1

endmodule