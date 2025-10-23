module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : FA_GEN_INLINE
            wire a = x[i];
            wire b = y[i];
            wire cin = (i == 0) ? 1'b0 : carry[i-1];

            // sum_i = a ^ b ^ cin
            assign sum[i] = a ^ b ^ cin;

            // carry_i = (a & b) | (b & cin) | (a & cin)
            assign carry[i] = (a & b) | (b & cin) | (a & cin);
        end
    endgenerate

    assign sum[4] = carry[3];
endmodule