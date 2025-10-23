module TopModule (
    input  clk,
    input  x,
    output z
);

    // Declare individual flip-flop outputs as registers
    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to zero before simulation starts
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

    // Combinational logic for D inputs of each flip-flop
    wire d_xor = x ^ ff_xor;      // XOR gate with ff_xor output
    wire d_and = x & ~ff_and;     // AND gate with complemented ff_and output
    wire d_or  = x | ~ff_or;      // OR gate with complemented ff_or output

    // Sequential logic: update flip-flops on the positive clock edge
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule