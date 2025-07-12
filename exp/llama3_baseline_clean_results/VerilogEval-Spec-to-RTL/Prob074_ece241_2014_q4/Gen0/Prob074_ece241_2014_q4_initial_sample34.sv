module TopModule(
    input  clk,
    input  x,
    output z
);

reg q_xor, q_and, q_or;

// Initialize flip-flops to 0
initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

always @(posedge clk) begin
    // XOR gate
    reg xor_out;
    assign xor_out = x ^ q_xor;
    q_xor <= xor_out;

    // AND gate
    reg and_out;
    assign and_out = x & ~q_and;
    q_and <= and_out;

    // OR gate
    reg or_out;
    assign or_out = x | ~q_or;
    q_or <= or_out;
end

// NOR gate
assign z = ~(q_xor | q_and | q_or);

endmodule