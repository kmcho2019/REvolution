module TopModule (
    input clk,
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    wire d_xor, d_and, d_or;

    // Compute D inputs for flip-flops
    assign d_xor = x ^ ff_xor;
    assign d_and = x & (~ff_and);
    assign d_or  = x | (~ff_or);

    // Flip-flops update on positive edge of clk
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

    // Initialize flip-flops to zero
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

endmodule