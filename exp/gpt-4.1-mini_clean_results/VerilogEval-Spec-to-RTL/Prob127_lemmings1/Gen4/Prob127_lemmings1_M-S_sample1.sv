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
        if (areset) begin
            state <= 1'b0; // walk_left
        end else begin
            case ({bump_left, bump_right})
                2'b00: state <= state;          // no bump, hold state
                2'b01: state <= 1'b0;           // bump_right, walk_left
                2'b10: state <= 1'b1;           // bump_left, walk_right
                2'b11: state <= ~state;         // bump both, invert direction
            endcase
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule