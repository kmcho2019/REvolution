module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Internal signals for each division step
    wire [16:0] remainder [0:16];  // 17-bit to handle carry
    wire [15:0] quotient;

    // Initialize with dividend padded with zero
    assign remainder[0] = {1'b0, A};

    // Unrolled division steps
    assign {quotient[15], remainder[1]} = (remainder[0][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[0][16:9] - B, remainder[0][8:0]} : 
                                         {1'b0, remainder[0] << 1};
    
    assign {quotient[14], remainder[2]} = (remainder[1][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[1][16:9] - B, remainder[1][8:0]} : 
                                         {1'b0, remainder[1] << 1};
    
    assign {quotient[13], remainder[3]} = (remainder[2][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[2][16:9] - B, remainder[2][8:0]} : 
                                         {1'b0, remainder[2] << 1};
    
    assign {quotient[12], remainder[4]} = (remainder[3][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[3][16:9] - B, remainder[3][8:0]} : 
                                         {1'b0, remainder[3] << 1};
    
    assign {quotient[11], remainder[5]} = (remainder[4][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[4][16:9] - B, remainder[4][8:0]} : 
                                         {1'b0, remainder[4] << 1};
    
    assign {quotient[10], remainder[6]} = (remainder[5][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[5][16:9] - B, remainder[5][8:0]} : 
                                         {1'b0, remainder[5] << 1};
    
    assign {quotient[9], remainder[7]} = (remainder[6][16:9] >= {1'b0, B}) ? 
                                        {1'b1, remainder[6][16:9] - B, remainder[6][8:0]} : 
                                        {1'b0, remainder[6] << 1};
    
    assign {quotient[8], remainder[8]} = (remainder[7][16:9] >= {1'b0, B}) ? 
                                        {1'b1, remainder[7][16:9] - B, remainder[7][8:0]} : 
                                        {1'b0, remainder[7] << 1};
    
    assign {quotient[7], remainder[9]} = (remainder[8][16:9] >= {1'b0, B}) ? 
                                        {1'b1, remainder[8][16:9] - B, remainder[8][8:0]} : 
                                        {1'b0, remainder[8] << 1};
    
    assign {quotient[6], remainder[10]} = (remainder[9][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[9][16:9] - B, remainder[9][8:0]} : 
                                         {1'b0, remainder[9] << 1};
    
    assign {quotient[5], remainder[11]} = (remainder[10][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[10][16:9] - B, remainder[10][8:0]} : 
                                         {1'b0, remainder[10] << 1};
    
    assign {quotient[4], remainder[12]} = (remainder[11][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[11][16:9] - B, remainder[11][8:0]} : 
                                         {1'b0, remainder[11] << 1};
    
    assign {quotient[3], remainder[13]} = (remainder[12][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[12][16:9] - B, remainder[12][8:0]} : 
                                         {1'b0, remainder[12] << 1};
    
    assign {quotient[2], remainder[14]} = (remainder[13][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[13][16:9] - B, remainder[13][8:0]} : 
                                         {1'b0, remainder[13] << 1};
    
    assign {quotient[1], remainder[15]} = (remainder[14][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[14][16:9] - B, remainder[14][8:0]} : 
                                         {1'b0, remainder[14] << 1};
    
    assign {quotient[0], remainder[16]} = (remainder[15][16:9] >= {1'b0, B}) ? 
                                         {1'b1, remainder[15][16:9] - B, remainder[15][8:0]} : 
                                         {1'b0, remainder[15] << 1};

    // Final outputs
    assign result = quotient;
    assign odd = remainder[16][15:0];

endmodule