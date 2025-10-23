module TopModule(clk, x, z);
    input clk;
    input x;
    output z;

    reg xor_out, and_out, or_out;
    reg q_xor, q_and, q_or;

    // Combinational logic for XOR gate
    assign xor_out = x ^ q_xor;

    // Combinational logic for AND gate
    assign and_out = x & ~q_and;

    // Combinational logic for OR gate
    assign or_out = x | ~q_or;

    // Sequential logic for D flip-flops
    always @(posedge clk) begin
        q_xor <= xor_out;
        q_and <= and_out;
        q_or <= or_out;
    end

    // Combinational logic for NOR gate
    assign z = ~(xor_out | and_out | or_out);

    // Initialize flip-flops to zero
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

endmodule