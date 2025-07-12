module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot encoding: state[0] = walk_left, state[1] = walk_right
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // walk_left
        end else begin
            case ({bump_left, bump_right})
                2'b10: state <= 2'b10;        // bump_left: walk_right
                2'b01: state <= 2'b01;        // bump_right: walk_left
                2'b11: state <= {state[0], state[1]}; // swap bits to toggle state
                default: state <= state;       // no bump: maintain current state
            endcase
        end
    end

    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule