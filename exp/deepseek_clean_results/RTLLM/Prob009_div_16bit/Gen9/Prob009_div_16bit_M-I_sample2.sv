module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit remainder
);

    wire [7:0] stage [0:16];  // 8-bit stages instead of 9-bit
    wire [15:0] quotient;

    assign stage[0] = 8'b0;

    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] temp = {stage[15-i], A[i]};
            assign quotient[i] = (temp >= {1'b0, B});
            assign stage[16-i] = quotient[i] ? temp - B : temp[7:0];
        end
    endgenerate

    assign result = quotient;
    assign odd = stage[16];  // Direct 8-bit remainder

endmodule