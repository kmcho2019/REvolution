module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding:
    // 0 = COPY bits (pass input directly)
    // 1 = INVERT bits (after first '1' detected)
    reg state;
    reg x_reg;

    // Sequential logic: sample input and update state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;    // initial state: copy bits
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            state <= (state == 1'b0) ? (x_reg ? 1'b1 : 1'b0) : 1'b1;
        end
    end

    // Combinational Moore output: output depends only on registered state and input
    always @(*) begin
        z = x_reg ^ state;
    end

endmodule