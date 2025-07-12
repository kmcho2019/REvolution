module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    wire d_xor, d_and, d_or;

    // Compute D inputs with explicit gate connections
    assign d_xor = x ^ ff_xor;        // XOR with flip-flop output
    assign d_and = x & (~ff_and);     // AND with complemented flip-flop output
    assign d_or  = x | (~ff_or);      // OR with complemented flip-flop output

    // Synchronous flip-flops update
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

    // Initialize flip-flops to zero before simulation starts
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

endmodule