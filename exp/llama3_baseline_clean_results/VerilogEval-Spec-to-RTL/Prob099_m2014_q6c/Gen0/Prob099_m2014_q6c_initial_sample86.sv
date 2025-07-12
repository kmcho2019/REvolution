module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 (y[1]) is set in state B
    assign Y1 = (y[0] && w) || (y[1] && w);  // A and w=1 or B and w=1

    // Y3 (y[3]) is set in state D
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w) || (y[5] && w);
        // B and w=1 or C and w=1 or D and w=1 or E and w=1 or F and w=1
endmodule