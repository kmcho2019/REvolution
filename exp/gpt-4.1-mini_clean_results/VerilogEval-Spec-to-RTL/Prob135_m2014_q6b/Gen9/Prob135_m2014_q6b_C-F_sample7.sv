module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states for clarity
    wire B = (~y2) & (~y1) &  y0;  // 001
    wire C = (~y2) &  y1  & (~y0); // 010
    wire E =  y2  & (~y1) & (~y0); // 100
    wire F =  y2  & (~y1) &  y0;   // 101

    // Factor the expression to minimize gate count and switching
    wire CE = C | E;
    wire next_y1 = B | F | (w & CE);

    assign Y1 = next_y1;

endmodule