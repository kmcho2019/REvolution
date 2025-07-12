module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;
    reg x_reg;

    // Sequential logic with async reset: sample input and update state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            state <= state | x_reg; // state becomes 1 after first sampled '1'
        end
    end

    // Moore output: invert input bit if state is 1, else pass through
    assign z = x_reg ^ state;

endmodule