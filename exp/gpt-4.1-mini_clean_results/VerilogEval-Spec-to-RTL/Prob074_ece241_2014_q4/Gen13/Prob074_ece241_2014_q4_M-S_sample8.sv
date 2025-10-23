module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Combinational logic for D inputs
    wire d_xor = x ^ ff_xor;
    wire d_and = x & ~ff_and;
    wire d_or  = x | ~ff_or;

    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule