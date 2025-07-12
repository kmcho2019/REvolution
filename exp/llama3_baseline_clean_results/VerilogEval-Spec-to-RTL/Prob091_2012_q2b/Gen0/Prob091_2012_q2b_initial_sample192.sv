module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // State A: 000001
    // State B: 000010
    // State C: 000100
    // State D: 001000
    // State E: 010000
    // State F: 100000

    assign Y1 = (y[0] && w);  // State A and w is 1
    assign Y3 = (~w && (y[1] || y[2] || y[4]));  // States B, C, or E and w is 0
endmodule