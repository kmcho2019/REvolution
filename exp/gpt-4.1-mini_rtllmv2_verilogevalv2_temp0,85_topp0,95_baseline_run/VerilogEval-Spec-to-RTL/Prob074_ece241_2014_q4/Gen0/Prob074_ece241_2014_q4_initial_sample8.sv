module TopModule(
    input clk,
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to zero at start
    initial begin
        ff_xor = 0;
        ff_and = 0;
        ff_or  = 0;
    end

    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // On positive edge of clk, update flip-flops
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // z is NOR of the three flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule