module TopModule(
    input  clk,
    input  x,
    output z
);

    reg xor_out, and_out, or_out;
    wire xor_input, and_input, or_input;

    // Complemented outputs of the flip-flops
    wire xor_out_complement, and_out_complement, or_out_complement;

    assign xor_input = x ^ xor_out;
    assign and_input = x & ~and_out;
    assign or_input = x | ~or_out;

    assign xor_out_complement = ~xor_out;
    assign and_out_complement = ~and_out;
    assign or_out_complement = ~or_out;

    always @(posedge clk) begin
        xor_out <= xor_input;
        and_out <= and_input;
        or_out <= or_input;
    end

    assign z = ~(xor_out | and_out | or_out);

endmodule