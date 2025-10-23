module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit
);

    wire [15:0] quotient;
    wire [7:0] stage [0:16];  // Reduced to 8-bit stages

    // Initialize stage 0
    assign stage[0] = 8'b0;

    // Generate all 16 stages
    genvar i;
    generate
        for (i=15; i>=0; i=i-1) begin : div_stages
            wire [8:0] temp = {stage[15-i], A[i]};
            wire [8:0] diff = temp - {1'b0, B};
            assign {quotient[i], stage[16-i]} = (temp >= {1'b0, B}) ? 
                                              {1'b1, diff[7:0]} : 
                                              {1'b0, temp[7:0]};
        end
    endgenerate

    // Output assignments
    assign result = quotient;
    assign odd = stage[16];  // Direct 8-bit output

endmodule