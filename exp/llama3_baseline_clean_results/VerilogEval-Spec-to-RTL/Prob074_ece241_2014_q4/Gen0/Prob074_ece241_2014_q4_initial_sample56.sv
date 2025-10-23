module TopModule(clk, x, z);
    input clk, x;
    output z;
    reg z;
    reg xor_out, and_out, or_out;
    reg q_xor, q_and, q_or;

    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

    always @(posedge clk) begin
        q_xor <= (x ^ q_xor);
        q_and <= (x & ~q_and);
        q_or <= (x | ~q_or);
    end

    assign xor_out = (x ^ q_xor);
    assign and_out = (x & ~q_and);
    assign or_out = (x | ~q_or);

    assign z = ~(xor_out | and_out | or_out);
endmodule