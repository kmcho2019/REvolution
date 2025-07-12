module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire [8:0] rem [0:15];  // 9-bit remainders (8 bits + carry)
    
    // First stage
    assign rem[15] = {1'b0, A[15]};
    assign result[15] = rem[15] >= {1'b0, B};
    
    // Intermediate stages
    assign rem[14] = result[15] ? (rem[15] - {1'b0, B}) << 1 | A[14] : rem[15] << 1 | A[14];
    assign result[14] = rem[14] >= {1'b0, B};
    
    assign rem[13] = result[14] ? (rem[14] - {1'b0, B}) << 1 | A[13] : rem[14] << 1 | A[13];
    assign result[13] = rem[13] >= {1'b0, B};
    
    assign rem[12] = result[13] ? (rem[13] - {1'b0, B}) << 1 | A[12] : rem[13] << 1 | A[12];
    assign result[12] = rem[12] >= {1'b0, B};
    
    assign rem[11] = result[12] ? (rem[12] - {1'b0, B}) << 1 | A[11] : rem[12] << 1 | A[11];
    assign result[11] = rem[11] >= {1'b0, B};
    
    assign rem[10] = result[11] ? (rem[11] - {1'b0, B}) << 1 | A[10] : rem[11] << 1 | A[10];
    assign result[10] = rem[10] >= {1'b0, B};
    
    assign rem[9] = result[10] ? (rem[10] - {1'b0, B}) << 1 | A[9] : rem[10] << 1 | A[9];
    assign result[9] = rem[9] >= {1'b0, B};
    
    assign rem[8] = result[9] ? (rem[9] - {1'b0, B}) << 1 | A[8] : rem[9] << 1 | A[8];
    assign result[8] = rem[8] >= {1'b0, B};
    
    assign rem[7] = result[8] ? (rem[8] - {1'b0, B}) << 1 | A[7] : rem[8] << 1 | A[7];
    assign result[7] = rem[7] >= {1'b0, B};
    
    assign rem[6] = result[7] ? (rem[7] - {1'b0, B}) << 1 | A[6] : rem[7] << 1 | A[6];
    assign result[6] = rem[6] >= {1'b0, B};
    
    assign rem[5] = result[6] ? (rem[6] - {1'b0, B}) << 1 | A[5] : rem[6] << 1 | A[5];
    assign result[5] = rem[5] >= {1'b0, B};
    
    assign rem[4] = result[5] ? (rem[5] - {1'b0, B}) << 1 | A[4] : rem[5] << 1 | A[4];
    assign result[4] = rem[4] >= {1'b0, B};
    
    assign rem[3] = result[4] ? (rem[4] - {1'b0, B}) << 1 | A[3] : rem[4] << 1 | A[3];
    assign result[3] = rem[3] >= {1'b0, B};
    
    assign rem[2] = result[3] ? (rem[3] - {1'b0, B}) << 1 | A[2] : rem[3] << 1 | A[2];
    assign result[2] = rem[2] >= {1'b0, B};
    
    assign rem[1] = result[2] ? (rem[2] - {1'b0, B}) << 1 | A[1] : rem[2] << 1 | A[1];
    assign result[1] = rem[1] >= {1'b0, B};
    
    assign rem[0] = result[1] ? (rem[1] - {1'b0, B}) << 1 | A[0] : rem[1] << 1 | A[0];
    assign result[0] = rem[0] >= {1'b0, B};
    
    // Final remainder output
    assign odd = (B == 8'b0) ? 8'b0 : 
                (result[0] ? (rem[0] - {1'b0, B})[7:0] : rem[0][7:0]);

endmodule