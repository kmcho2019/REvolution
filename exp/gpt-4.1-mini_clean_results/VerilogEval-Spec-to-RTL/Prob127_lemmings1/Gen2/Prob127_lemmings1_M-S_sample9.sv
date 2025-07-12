module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else begin
            case ({bump_left, bump_right})
                2'b10: state <= 1'b1;        // bumped left -> walk right
                2'b01: state <= 1'b0;        // bumped right -> walk left
                2'b11: state <= ~state;      // both bumps -> toggle direction
                default: state <= state;     // no bump -> hold state
            endcase
        end
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule