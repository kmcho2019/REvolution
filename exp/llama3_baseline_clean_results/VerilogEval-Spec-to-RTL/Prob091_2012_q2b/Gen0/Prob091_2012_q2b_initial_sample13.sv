module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 is set in states B and E
    // State B: y[5:0] = 000010
    // State E: y[5:0] = 010000
    assign Y1 = (y[1] & ~w) | (y[4] & w);

    // Y3 is set in states D and F
    // State D: y[5:0] = 001000
    // State F: y[5:0] = 100000
    assign Y3 = (y[3] & (~w | ~y[5])) | (y[5] & w);
endmodule