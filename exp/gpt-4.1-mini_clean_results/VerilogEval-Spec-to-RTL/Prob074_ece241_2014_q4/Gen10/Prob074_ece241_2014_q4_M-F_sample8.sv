module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to zero before simulation begins
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

    // Combinational logic for the D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic with positive edge clock
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output is the NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule