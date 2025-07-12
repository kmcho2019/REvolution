module TopModule(
    input  [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        out_and = in[0] & in[1] & in[2] & in[3]; // Using explicit AND operation for clarity
        out_or  = in[0] | in[1] | in[2] | in[3]; // Using explicit OR operation for clarity
        out_xor = in[0] ^ in[1] ^ in[2] ^ in[3]; // Using explicit XOR operation for clarity
        // Alternatively, the following reduction operators could be used for a more compact representation:
        // out_and = &in;
        // out_or  = |in;
        // out_xor = ^in;
    end

endmodule