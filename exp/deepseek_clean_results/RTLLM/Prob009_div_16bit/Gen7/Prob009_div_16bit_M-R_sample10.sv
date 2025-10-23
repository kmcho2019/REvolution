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
    assign {quotient[15], stage[1]} = (stage[0] << 1 | {8'b0, A[15]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[0] << 1 | {8'b0, A[15]}) - {1'b0, B}} : 
                                     {1'b0, (stage[0] << 1 | {8'b0, A[15]})};

    assign {quotient[14], stage[2]} = (stage[1] << 1 | {8'b0, A[14]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[1] << 1 | {8'b0, A[14]}) - {1'b0, B}} : 
                                     {1'b0, (stage[1] << 1 | {8'b0, A[14]})};

    assign {quotient[13], stage[3]} = (stage[2] << 1 | {8'b0, A[13]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[2] << 1 | {8'b0, A[13]}) - {1'b0, B}} : 
                                     {1'b0, (stage[2] << 1 | {8'b0, A[13]})};

    // Continue similar assignments for bits 12 through 1
    assign {quotient[12], stage[4]} = (stage[3] << 1 | {8'b0, A[12]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[3] << 1 | {8'b0, A[12]}) - {1'b0, B}} : 
                                     {1'b0, (stage[3] << 1 | {8'b0, A[12]})};

    assign {quotient[11], stage[5]} = (stage[4] << 1 | {8'b0, A[11]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[4] << 1 | {8'b0, A[11]}) - {1'b0, B}} : 
                                     {1'b0, (stage[4] << 1 | {8'b0, A[11]})};

    assign {quotient[10], stage[6]} = (stage[5] << 1 | {8'b0, A[10]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[5] << 1 | {8'b0, A[10]}) - {1'b0, B}} : 
                                     {1'b0, (stage[5] << 1 | {8'b0, A[10]})};

    assign {quotient[9], stage[7]} = (stage[6] << 1 | {8'b0, A[9]}) >= {1'b0, B} ? 
                                    {1'b1, (stage[6] << 1 | {8'b0, A[9]}) - {1'b0, B}} : 
                                    {1'b0, (stage[6] << 1 | {8'b0, A[9]})};

    assign {quotient[8], stage[8]} = (stage[7] << 1 | {8'b0, A[8]}) >= {1'b0, B} ? 
                                    {1'b1, (stage[7] << 1 | {8'b0, A[8]}) - {1'b0, B}} : 
                                    {1'b0, (stage[7] << 1 | {8'b0, A[8]})};

    assign {quotient[7], stage[9]} = (stage[8] << 1 | {8'b0, A[7]}) >= {1'b0, B} ? 
                                    {1'b1, (stage[8] << 1 | {8'b0, A[7]}) - {1'b0, B}} : 
                                    {1'b0, (stage[8] << 1 | {8'b0, A[7]})};

    assign {quotient[6], stage[10]} = (stage[9] << 1 | {8'b0, A[6]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[9] << 1 | {8'b0, A[6]}) - {1'b0, B}} : 
                                     {1'b0, (stage[9] << 1 | {8'b0, A[6]})};

    assign {quotient[5], stage[11]} = (stage[10] << 1 | {8'b0, A[5]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[10] << 1 | {8'b0, A[5]}) - {1'b0, B}} : 
                                     {1'b0, (stage[10] << 1 | {8'b0, A[5]})};

    assign {quotient[4], stage[12]} = (stage[11] << 1 | {8'b0, A[4]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[11] << 1 | {8'b0, A[4]}) - {1'b0, B}} : 
                                     {1'b0, (stage[11] << 1 | {8'b0, A[4]})};

    assign {quotient[3], stage[13]} = (stage[12] << 1 | {8'b0, A[3]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[12] << 1 | {8'b0, A[3]}) - {1'b0, B}} : 
                                     {1'b0, (stage[12] << 1 | {8'b0, A[3]})};

    assign {quotient[2], stage[14]} = (stage[13] << 1 | {8'b0, A[2]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[13] << 1 | {8'b0, A[2]}) - {1'b0, B}} : 
                                     {1'b0, (stage[13] << 1 | {8'b0, A[2]})};

    assign {quotient[1], stage[15]} = (stage[14] << 1 | {8'b0, A[1]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[14] << 1 | {8'b0, A[1]}) - {1'b0, B}} : 
                                     {1'b0, (stage[14] << 1 | {8'b0, A[1]})};

    assign {quotient[0], stage[16]} = (stage[15] << 1 | {8'b0, A[0]}) >= {1'b0, B} ? 
                                     {1'b1, (stage[15] << 1 | {8'b0, A[0]}) - {1'b0, B}} : 
                                     {1'b0, (stage[15] << 1 | {8'b0, A[0]})};

    // Output assignments
    assign result = quotient;
    assign odd = {7'b0, stage[16]};

endmodule