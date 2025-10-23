module TopModule(clk, x, z);
    input clk;
    input x;
    output z;
    reg xor_out, and_out, or_out;
    reg prev_xor_out, prev_and_out, prev_or_out;

    assign z = ~(xor_out | and_out | or_out);

    always @(posedge clk) begin
        prev_xor_out <= xor_out;
        prev_and_out <= and_out;
        prev_or_out <= or_out;
    end

    assign xor_out = x ^ prev_xor_out;
    assign and_out = x & ~prev_and_out;
    assign or_out = x | ~prev_or_out;

    initial begin
        prev_xor_out = 0;
        prev_and_out = 0;
        prev_or_out = 0;
    end
endmodule