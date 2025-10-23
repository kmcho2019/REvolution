module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else begin
            case (state)
                0: state <= bump_left ? 1 : 0;
                1: state <= bump_right ? 0 : 1;
            endcase
        end
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule