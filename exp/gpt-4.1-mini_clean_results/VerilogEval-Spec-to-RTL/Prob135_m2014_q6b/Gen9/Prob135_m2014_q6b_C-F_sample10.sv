module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // State bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Minimal partial decoding for states influencing next_y1
    wire B = (~y2) & (~y1) &  y0;  // 001
    wire C = (~y2) &  y1  & (~y0); // 010
    wire E =  y2  & (~y1) & (~y0); // 100
    wire F =  y2  & (~y1) &  y0;   // 101

    // Minimized next-state logic for y[1]:
    // next_y1 = B | F | ((C | E) & w);
    wire next_y1 = B | F | ((C | E) & w);

    // Output Y1 is the next y[1] combinational logic as required
    assign Y1 = next_y1;

endmodule