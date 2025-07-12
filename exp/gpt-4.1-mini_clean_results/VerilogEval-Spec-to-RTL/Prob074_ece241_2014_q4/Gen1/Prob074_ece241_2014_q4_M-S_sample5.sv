module TopModule (
    input clk,
    input x,
    output z
);
    reg ff_xor = 0, ff_and = 0, ff_or = 0;

    always @(posedge clk) begin
        ff_xor <= x ^ ff_xor;
        ff_and <= x & ~ff_and;
        ff_or  <= x | ~ff_or;
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule