module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    wire d_xor = x ^ q_xor;      // XOR gate: input x and q_xor output
    wire d_and = x & (~q_and);   // AND gate: input x and complement of q_and output
    wire d_or  = x | (~q_or);    // OR gate: input x and complement of q_or output

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    assign z = ~(q_xor | q_and | q_or); // NOR of the three flip-flop outputs

endmodule