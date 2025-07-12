module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate wires for bit-serial division
    wire [8:0] remainder [0:16];
    
    // Initialize with first bit
    assign remainder[16] = {8'b0, A[15]};
    
    // Generate each bit of quotient and remainder
    assign result[15] = (remainder[16] >= {1'b0, B});
    assign remainder[15] = result[15] ? (remainder[16] - {1'b0, B}) : remainder[16];
    
    assign result[14] = ({remainder[15][7:0], A[14]} >= {1'b0, B});
    assign remainder[14] = result[14] ? ({remainder[15][7:0], A[14]} - {1'b0, B}) : {remainder[15][7:0], A[14]};
    
    assign result[13] = ({remainder[14][7:0], A[13]} >= {1'b0, B});
    assign remainder[13] = result[13] ? ({remainder[14][7:0], A[13]} - {1'b0, B}) : {remainder[14][7:0], A[13]};
    
    assign result[12] = ({remainder[13][7:0], A[12]} >= {1'b0, B});
    assign remainder[12] = result[12] ? ({remainder[13][7:0], A[12]} - {1'b0, B}) : {remainder[13][7:0], A[12]};
    
    assign result[11] = ({remainder[12][7:0], A[11]} >= {1'b0, B});
    assign remainder[11] = result[11] ? ({remainder[12][7:0], A[11]} - {1'b0, B}) : {remainder[12][7:0], A[11]};
    
    assign result[10] = ({remainder[11][7:0], A[10]} >= {1'b0, B});
    assign remainder[10] = result[10] ? ({remainder[11][7:0], A[10]} - {1'b0, B}) : {remainder[11][7:0], A[10]};
    
    assign result[9] = ({remainder[10][7:0], A[9]} >= {1'b0, B});
    assign remainder[9] = result[9] ? ({remainder[10][7:0], A[9]} - {1'b0, B}) : {remainder[10][7:0], A[9]};
    
    assign result[8] = ({remainder[9][7:0], A[8]} >= {1'b0, B});
    assign remainder[8] = result[8] ? ({remainder[9][7:0], A[8]} - {1'b0, B}) : {remainder[9][7:0], A[8]};
    
    assign result[7] = ({remainder[8][7:0], A[7]} >= {1'b0, B});
    assign remainder[7] = result[7] ? ({remainder[8][7:0], A[7]} - {1'b0, B}) : {remainder[8][7:0], A[7]};
    
    assign result[6] = ({remainder[7][7:0], A[6]} >= {1'b0, B});
    assign remainder[6] = result[6] ? ({remainder[7][7:0], A[6]} - {1'b0, B}) : {remainder[7][7:0], A[6]};
    
    assign result[5] = ({remainder[6][7:0], A[5]} >= {1'b0, B});
    assign remainder[5] = result[5] ? ({remainder[6][7:0], A[5]} - {1'b0, B}) : {remainder[6][7:0], A[5]};
    
    assign result[4] = ({remainder[5][7:0], A[4]} >= {1'b0, B});
    assign remainder[4] = result[4] ? ({remainder[5][7:0], A[4]} - {1'b0, B}) : {remainder[5][7:0], A[4]};
    
    assign result[3] = ({remainder[4][7:0], A[3]} >= {1'b0, B});
    assign remainder[3] = result[3] ? ({remainder[4][7:0], A[3]} - {1'b0, B}) : {remainder[4][7:0], A[3]};
    
    assign result[2] = ({remainder[3][7:0], A[2]} >= {1'b0, B});
    assign remainder[2] = result[2] ? ({remainder[3][7:0], A[2]} - {1'b0, B}) : {remainder[3][7:0], A[2]};
    
    assign result[1] = ({remainder[2][7:0], A[1]} >= {1'b0, B});
    assign remainder[1] = result[1] ? ({remainder[2][7:0], A[1]} - {1'b0, B}) : {remainder[2][7:0], A[1]};
    
    assign result[0] = ({remainder[1][7:0], A[0]} >= {1'b0, B});
    assign remainder[0] = result[0] ? ({remainder[1][7:0], A[0]} - {1'b0, B}) : {remainder[1][7:0], A[0]};
    
    // Final remainder output (only need lower 8 bits)
    assign odd = remainder[0][7:0];

endmodule