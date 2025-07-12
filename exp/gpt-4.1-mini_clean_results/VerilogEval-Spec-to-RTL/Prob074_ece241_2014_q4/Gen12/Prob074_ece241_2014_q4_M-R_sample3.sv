module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;

    // Combinational D inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Sequential logic: flip-flops capture D inputs on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Initial condition for simulation, flip-flops start at zero
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule