module TopModule (
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output       f
);

    // Row bits: x[3], x[2]
    // Column bits: x[1], x[0]
    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];

    // Decode rows and columns into one-hot signals
    wire [3:0] row_decode = 4'b0001 << row;
    wire [3:0] col_decode = 4'b0001 << col;

    // Karnaugh map (rows x cols)
    // rows: 00=0, 01=1, 10=2, 11=3
    // cols: 00=0, 01=1, 11=2, 10=3

    // Given Karnaugh map cells:

    // Row 0 (00): d 0 d d
    //  col0(00): d -> treat as 0
    //  col1(01): 0
    //  col2(11): d -> 0
    //  col3(10): d -> 0

    // Row 1 (01): 0 d 1 0
    // col0(00): 0
    // col1(01): d -> 0
    // col2(11): 1
    // col3(10): 0

    // Row 2 (10): 1 1 0 d
    // col0(00):1
    // col1(01):1
    // col2(11):0
    // col3(10):d ->0

    // Row 3 (11): 1 1 d d
    // col0(00):1
    // col1(01):1
    // col2(11):d ->0
    // col3(10):d ->0

    // Now list the minterms where f=1:

    wire m_2_0 = row_decode[2] & col_decode[0]; // row=10, col=00
    wire m_2_1 = row_decode[2] & col_decode[1]; // row=10, col=01
    wire m_3_0 = row_decode[3] & col_decode[0]; // row=11, col=00
    wire m_3_1 = row_decode[3] & col_decode[1]; // row=11, col=01
    wire m_1_2 = row_decode[1] & col_decode[2]; // row=01, col=11

    assign f = m_2_0 | m_2_1 | m_3_0 | m_3_1 | m_1_2;

endmodule