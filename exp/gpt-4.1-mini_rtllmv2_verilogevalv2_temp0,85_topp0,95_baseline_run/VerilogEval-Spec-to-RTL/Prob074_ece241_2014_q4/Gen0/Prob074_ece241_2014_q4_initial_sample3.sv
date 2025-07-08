module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // Compute D inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    // Sequential logic: D flip-flops updated on posedge clk, initialized to 0
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // 3-input NOR gate for output z
    assign z = ~(q_xor | q_and | q_or);

endmodule