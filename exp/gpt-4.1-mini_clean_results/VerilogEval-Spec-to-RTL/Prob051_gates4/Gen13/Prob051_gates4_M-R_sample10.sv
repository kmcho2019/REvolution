module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output reg        out_and,
    output reg        out_or,
    output reg        out_xor
);

    // Internal wires for balanced XOR
    reg xor_stage1_0, xor_stage1_1;

    always @(*) begin
        // Compute AND and OR using reduction operators
        out_and = &in;
        out_or  = |in;

        // Balanced XOR tree for 4 inputs
        xor_stage1_0 = in[0] ^ in[1];
        xor_stage1_1 = in[2] ^ in[3];
        out_xor      = xor_stage1_0 ^ xor_stage1_1;
    end

endmodule