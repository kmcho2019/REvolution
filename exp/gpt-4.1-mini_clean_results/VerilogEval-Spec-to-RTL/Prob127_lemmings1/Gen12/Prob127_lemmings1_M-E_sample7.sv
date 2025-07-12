module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left_r, walk_right_r;

    // On reset, initialize walk_left=1, walk_right=0 (one-hot encoding)
    // On each clock, update state according to bump signals
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_r  <= 1'b1;
            walk_right_r <= 1'b0;
        end else begin
            case ({bump_left, bump_right})
                2'b00: begin
                    // no bump, maintain current state
                    walk_left_r  <= walk_left_r;
                    walk_right_r <= walk_right_r;
                end
                2'b01: begin
                    // bump right: walk left
                    walk_left_r  <= 1'b1;
                    walk_right_r <= 1'b0;
                end
                2'b10: begin
                    // bump left: walk right
                    walk_left_r  <= 1'b0;
                    walk_right_r <= 1'b1;
                end
                2'b11: begin
                    // bump both: invert direction
                    walk_left_r  <= walk_right_r;
                    walk_right_r <= walk_left_r;
                end
            endcase
        end
    end

    assign walk_left  = walk_left_r;
    assign walk_right = walk_right_r;

endmodule