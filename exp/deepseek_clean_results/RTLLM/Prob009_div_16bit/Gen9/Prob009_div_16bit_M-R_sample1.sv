module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate remainders for each bit stage
    wire [8:0] rem [0:16];
    
    // Initialize stage 0
    assign rem[0] = 9'b0;

    // Bit 15 processing
    assign {result[15], rem[1]} = ({rem[0][7:0], A[15]} >= B) ? 
                                 {1'b1, {rem[0][7:0], A[15]} - B} : 
                                 {1'b0, {rem[0][7:0], A[15]}};

    // Bit 14 processing
    assign {result[14], rem[2]} = ({rem[1][7:0], A[14]} >= B) ? 
                                 {1'b1, {rem[1][7:0], A[14]} - B} : 
                                 {1'b0, {rem[1][7:0], A[14]}};

    // Continue this pattern for all bits...
    // Bit 13
    assign {result[13], rem[3]} = ({rem[2][7:0], A[13]} >= B) ? 
                                 {1'b1, {rem[2][7:0], A[13]} - B} : 
                                 {1'b0, {rem[2][7:0], A[13]}};
    
    // Bit 12
    assign {result[12], rem[4]} = ({rem[3][7:0], A[12]} >= B) ? 
                                 {1'b1, {rem[3][7:0], A[12]} - B} : 
                                 {1'b0, {rem[3][7:0], A[12]}};

    // Bit 11
    assign {result[11], rem[5]} = ({rem[4][7:0], A[11]} >= B) ? 
                                 {1'b1, {rem[4][7:0], A[11]} - B} : 
                                 {1'b0, {rem[4][7:0], A[11]}};

    // Bit 10
    assign {result[10], rem[6]} = ({rem[5][7:0], A[10]} >= B) ? 
                                 {1'b1, {rem[5][7:0], A[10]} - B} : 
                                 {1'b0, {rem[5][7:0], A[10]}};

    // Bit 9
    assign {result[9], rem[7]} = ({rem[6][7:0], A[9]} >= B) ? 
                                {1'b1, {rem[6][7:0], A[9]} - B} : 
                                {1'b0, {rem[6][7:0], A[9]}};

    // Bit 8
    assign {result[8], rem[8]} = ({rem[7][7:0], A[8]} >= B) ? 
                                {1'b1, {rem[7][7:0], A[8]} - B} : 
                                {1'b0, {rem[7][7:0], A[8]}};

    // Bit 7
    assign {result[7], rem[9]} = ({rem[8][7:0], A[7]} >= B) ? 
                                {1'b1, {rem[8][7:0], A[7]} - B} : 
                                {1'b0, {rem[8][7:0], A[7]}};

    // Bit 6
    assign {result[6], rem[10]} = ({rem[9][7:0], A[6]} >= B) ? 
                                 {1'b1, {rem[9][7:0], A[6]} - B} : 
                                 {1'b0, {rem[9][7:0], A[6]}};

    // Bit 5
    assign {result[5], rem[11]} = ({rem[10][7:0], A[5]} >= B) ? 
                                 {1'b1, {rem[10][7:0], A[5]} - B} : 
                                 {1'b0, {rem[10][7:0], A[5]}};

    // Bit 4
    assign {result[4], rem[12]} = ({rem[11][7:0], A[4]} >= B) ? 
                                 {1'b1, {rem[11][7:0], A[4]} - B} : 
                                 {1'b0, {rem[11][7:0], A[4]}};

    // Bit 3
    assign {result[3], rem[13]} = ({rem[12][7:0], A[3]} >= B) ? 
                                 {1'b1, {rem[12][7:0], A[3]} - B} : 
                                 {1'b0, {rem[12][7:0], A[3]}};

    // Bit 2
    assign {result[2], rem[14]} = ({rem[13][7:0], A[2]} >= B) ? 
                                 {1'b1, {rem[13][7:0], A[2]} - B} : 
                                 {1'b0, {rem[13][7:0], A[2]}};

    // Bit 1
    assign {result[1], rem[15]} = ({rem[14][7:0], A[1]} >= B) ? 
                                 {1'b1, {rem[14][7:0], A[1]} - B} : 
                                 {1'b0, {rem[14][7:0], A[1]}};

    // Bit 0 (final stage)
    assign {result[0], rem[16]} = ({rem[15][7:0], A[0]} >= B) ? 
                                 {1'b1, {rem[15][7:0], A[0]} - B} : 
                                 {1'b0, {rem[15][7:0], A[0]}};

    // Final remainder output
    assign odd = {8'b0, rem[16][7:0]};

endmodule