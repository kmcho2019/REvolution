module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // LUT-style next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        ({y,w} == 4'b0000) ? 1'b0 :  // A,0→B
        ({y,w} == 4'b0001) ? 1'b0 :  // A,1→A
        ({y,w} == 4'b0010) ? 1'b0 :  // B,0→C
        ({y,w} == 4'b0011) ? 1'b1 :  // B,1→D
        ({y,w} == 4'b0100) ? 1'b1 :  // C,0→E
        ({y,w} == 4'b0101) ? 1'b1 :  // C,1→D
        ({y,w} == 4'b0110) ? 1'b1 :  // D,0→F
        ({y,w} == 4'b0111) ? 1'b0 :  // D,1→A
        ({y,w} == 4'b1000) ? 1'b1 :  // E,0→E
        ({y,w} == 4'b1001) ? 1'b1 :  // E,1→D
        ({y,w} == 4'b1010) ? 1'b1 :  // F,0→C
        ({y,w} == 4'b1011) ? 1'b1;   // F,1→D

endmodule