module TopModule(
    input  [3:0] x,
    output       f
);

    // Define outputs for each row (based on {x[2], x[3]})
    // Each 4-bit vector corresponds to f for x[0]x[1] = 00,01,11,10 respectively.

    // Karnaugh map rows:
    // 00: bits for x[0]x[1] = 00(1), 01(0), 11(0), 10(1) -> 4'b1001
    // 01: 4'b0000
    // 11: 4'b1110
    // 10: 4'b1101

    wire [3:0] row0 = 4'b1001;
    wire [3:0] row1 = 4'b0000;
    wire [3:0] row3 = 4'b1110; // row index '11' = 3
    wire [3:0] row2 = 4'b1101; // row index '10' = 2

    // Select the row vector based on {x[2], x[3]}
    // Use a 4-to-1 mux
    wire [3:0] row_selected;
    assign row_selected = ( {x[2], x[3]} == 2'b00 ) ? row0 :
                          ( {x[2], x[3]} == 2'b01 ) ? row1 :
                          ( {x[2], x[3]} == 2'b10 ) ? row2 :
                                                      row3 ;

    // Now select the output bit from row_selected based on x[0], x[1]
    // Recall columns are x[0]x[1] in order 00,01,11,10
    // To index into row_selected, map x[0]x[1] to bit index: 
    // bits: 0->00, 1->01, 2->11, 3->10
    // So we need a small function to map {x[0], x[1]} to bit index in row_selected

    wire [1:0] col_index;
    assign col_index = (x[1]) ? ( (x[0]) ? 2'd2 : 2'd1 ) : ( (x[0]) ? 2'd3 : 2'd0 );

    assign f = row_selected[col_index];

endmodule