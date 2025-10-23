module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [15:0] divisor_ext = {8'b0, B};
    wire [15:0] remainder [0:16];
    wire [15:0] quotient [0:16];

    // Initialize
    assign remainder[0] = 16'b0;
    assign quotient[0] = 16'b0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_stage
            wire [15:0] shifted_remainder = {remainder[i][14:0], A[15-i]};
            
            assign quotient[i+1] = (shifted_remainder >= divisor_ext) ? 
                                 {quotient[i][14:0], 1'b1} : 
                                 {quotient[i][14:0], 1'b0};
            
            assign remainder[i+1] = (shifted_remainder >= divisor_ext) ? 
                                  (shifted_remainder - divisor_ext) : 
                                  shifted_remainder;
        end
    endgenerate

    assign result = quotient[16];
    assign odd = remainder[16];

endmodule