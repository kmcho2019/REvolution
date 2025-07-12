module TopModule (
    input  clk,
    input  x,
    output z
);

    // Initialize registers to zero at declaration to ensure known startup state
    reg ff_xor = 1'b0;
    reg ff_and = 1'b0;
    reg ff_or  = 1'b0;

    // Combinational logic inputs for flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & ~ff_and;
    wire d_or  = x | ~ff_or;

    // Sequential logic: update flip-flops on positive clock edge
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output logic: NOR of flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule