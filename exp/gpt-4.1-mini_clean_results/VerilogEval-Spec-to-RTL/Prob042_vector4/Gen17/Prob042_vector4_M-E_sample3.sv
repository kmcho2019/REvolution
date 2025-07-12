module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    wire sign = in[7];
    // For each upper bit (31 down to 8), assign sign bit value conditionally
    // If sign == 1, bit = 1; else bit = 0
    // Lower 8 bits are the original input bits

    genvar i;
    wire [31:8] upper_bits;

    generate
        for (i = 8; i < 32; i = i + 1) begin : gen_sign_extend
            assign upper_bits[i-8] = sign ? 1'b1 : 1'b0;
        end
    endgenerate

    assign out = {upper_bits, in};

endmodule