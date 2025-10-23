module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    wire d_xor = x ^ ff_xor;
    wire d_and = x & ~ff_and;
    wire d_or  = x | ~ff_or;

    // Synchronous reset to zero on first clock cycle
    // Assuming reset is implicit on start (simulate reset on first clock)
    // Alternatively, reset can be controlled externally if needed
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule