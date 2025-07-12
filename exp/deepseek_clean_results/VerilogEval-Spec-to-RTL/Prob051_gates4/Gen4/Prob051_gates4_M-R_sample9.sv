module TopModule(
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @* begin
        // Reduction operators for AND and OR
        out_and = &in;
        out_or  = |in;

        // Balanced XOR tree
        out_xor = (in[0] ^ in[1]) ^ (in[2] ^ in[3]);
    end

endmodule