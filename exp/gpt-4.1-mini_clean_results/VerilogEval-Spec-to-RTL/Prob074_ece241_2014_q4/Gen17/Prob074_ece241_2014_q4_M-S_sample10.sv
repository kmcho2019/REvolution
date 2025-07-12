module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    reg reset = 1'b1;  // internal reset active at start

    wire d_xor = x ^ ff_xor;
    wire d_and = x & ~ff_and;
    wire d_or  = x | ~ff_or;

    always @(posedge clk) begin
        if (reset) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
            reset  <= 1'b0;  // deactivate reset after first clock
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule