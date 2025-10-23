module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg state;      // 0: copy bits until first '1'; 1: invert bits after first '1'
    reg x_reg;
    reg next_state;

    // Sample input and update state in sequential always block with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            1'b0: next_state = x_reg ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    // Output combinational logic (Moore output)
    assign z = (state == 1'b0) ? x_reg : ~x_reg;

endmodule