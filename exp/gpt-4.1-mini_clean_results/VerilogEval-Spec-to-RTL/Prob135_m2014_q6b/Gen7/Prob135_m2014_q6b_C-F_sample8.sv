module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Explicit state decoding for clarity
    wire B = (~y2) & (~y1) &  y0;  // 001
    wire C = (~y2) &  y1  & (~y0); // 010
    wire E =  y2  & (~y1) & (~y0); // 100
    wire F =  y2  & (~y1) &  y0;   // 101

    // Optimized next y[1] logic minimizing gate count and switching
    wire next_y1 = B | F | ((C | E) & w);

    // Output assignment as next state bit y[1]
    assign Y1 = next_y1;

endmodule