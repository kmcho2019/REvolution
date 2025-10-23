module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // One-hot encoding
    parameter LEFT = 2'b01;
    parameter RIGHT = 2'b10;
    
    reg [1:0] state;  // LEFT or RIGHT (one-hot)

    // Clock gating logic
    wire state_change = (state == LEFT && bump_left) || 
                       (state == RIGHT && bump_right);
    wire gated_clk = clk & (areset | state_change);

    // State transition with async reset
    always @(posedge gated_clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else case (state)
            LEFT:  state <= RIGHT;
            RIGHT: state <= LEFT;
        endcase
    end

    // Direct output assignments (no logic needed)
    assign walk_left = state[0];
    assign walk_right = state[1];

endmodule