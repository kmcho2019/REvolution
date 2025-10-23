module TopModule (
    input  clk,
    input  reset_n,  // Active-low asynchronous reset input
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= x ^ ff_xor;
            ff_and <= x & ~ff_and;
            ff_or  <= x | ~ff_or;
        end
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule