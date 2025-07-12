module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    reg reset;

    // Power-on reset: reset is asserted initially, deasserted after first clock edge
    initial reset = 1;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset of flip-flops
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
            reset <= 1'b0; // Deassert reset after first clock edge
        end else begin
            ff_xor <= x ^ ff_xor;
            ff_and <= x & ~ff_and;
            ff_or  <= x | ~ff_or;
        end
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule