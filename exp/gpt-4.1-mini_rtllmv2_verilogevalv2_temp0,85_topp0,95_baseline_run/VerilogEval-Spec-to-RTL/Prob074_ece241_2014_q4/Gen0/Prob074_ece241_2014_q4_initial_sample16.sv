module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor;
    reg ff_and;
    reg ff_or;

    // Initialize flip-flops to zero before simulation
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

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