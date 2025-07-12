module TopModule (
    input  clk,
    input  x,
    output z
);

    // Registered outputs
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Combinational logic for D inputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Sequential logic: D flip-flops updated on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output logic: NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule