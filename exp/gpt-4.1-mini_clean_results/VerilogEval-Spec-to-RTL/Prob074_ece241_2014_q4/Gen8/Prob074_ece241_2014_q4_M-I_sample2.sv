module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor = 0;
    reg ff_and = 0;
    reg ff_or  = 0;

    wire xor_in = x ^ ff_xor;
    wire and_in = x & ~ff_and;
    wire or_in  = x | ~ff_or;

    always @(posedge clk) begin
        ff_xor <= xor_in;
        ff_and <= and_in;
        ff_or  <= or_in;
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule