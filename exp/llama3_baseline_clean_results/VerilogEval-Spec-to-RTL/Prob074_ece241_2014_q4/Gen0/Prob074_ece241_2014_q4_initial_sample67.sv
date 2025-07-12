module TopModule(clk, x, z);
    input clk, x;
    output z;
    reg q0, q1, q2;  // Outputs of the D flip-flops
    wire xor_out, and_out, or_out;  // Outputs of the gates

    // Implement the gates
    assign xor_out = x ^ q0;
    assign and_out = x & ~q1;
    assign or_out = x | ~q2;

    // Implement the D flip-flops
    always @(posedge clk) begin
        q0 <= xor_out;
        q1 <= and_out;
        q2 <= or_out;
    end

    // Implement the NOR gate
    assign z = ~(xor_out | and_out | or_out);

    // Initialize the D flip-flops to zero
    initial begin
        q0 = 0;
        q1 = 0;
        q2 = 0;
    end
endmodule