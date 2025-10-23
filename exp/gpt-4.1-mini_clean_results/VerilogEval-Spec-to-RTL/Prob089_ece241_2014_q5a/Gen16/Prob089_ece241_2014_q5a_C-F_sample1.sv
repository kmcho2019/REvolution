module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;
    reg x_reg;

    // Input sampling register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with async reset: state becomes 1 after first sampled '1'
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= state | x_reg;
    end

    // Moore output: invert input bit if state is 1, else pass through input
    assign z = x_reg ^ state;

endmodule