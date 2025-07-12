module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for each stage
    wire [8:0] stage [0:16];
    wire [15:0] quotient;

    // Initialize stage 0
    assign stage[0] = 9'b0;

    // Unrolled loop for each bit
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            assign {quotient[i], stage[16-i]} = 
                (stage[15-i] << 1 | {8'b0, A[i]}) >= {1'b0, B} ? 
                {1'b1, (stage[15-i] << 1 | {8'b0, A[i]}) - {1'b0, B}} : 
                {1'b0, (stage[15-i] << 1 | {8'b0, A[i]})};
        end
    endgenerate

    // Output assignments
    assign result = quotient;
    assign odd = {7'b0, stage[16]};

endmodule