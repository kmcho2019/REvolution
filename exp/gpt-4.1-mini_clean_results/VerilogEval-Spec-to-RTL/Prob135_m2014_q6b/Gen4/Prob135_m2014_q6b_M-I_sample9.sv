module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire B = (~y2) & (~y1) &  y0;  // 001
    wire C = (~y2) &  y1  & (~y0); // 010
    wire E =  y2  & (~y1) & (~y0); // 100
    wire F =  y2  & (~y1) &  y0;  // 101

    // Simplified next y[1] logic
    wire next_y1 = B | F | ((C | E) & w);

    // Output assignment
    assign Y1 = next_y1;

endmodule