module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

    reg q_reg;

    // Synchronous data latch
    always @(posedge clk) begin
        if (!ar) begin
            q_reg <= d;
        end
    end

    // Asynchronous reset effect applied via continuous assignment
    assign q = ar ? 1'b0 : q_reg;

endmodule