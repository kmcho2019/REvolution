module TopModule(
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // D input signals
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops initialized to zero on simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Flip-flop updates on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule