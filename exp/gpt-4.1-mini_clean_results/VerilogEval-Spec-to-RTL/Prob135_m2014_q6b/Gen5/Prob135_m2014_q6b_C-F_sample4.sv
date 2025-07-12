module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states explicitly for clarity
    wire B = (~y2) & (~y1) &  y0;
    wire C = (~y2) &  y1  & (~y0);
    wire E =  y2  & (~y1) & (~y0);
    wire F =  y2  & (~y1) &  y0;

    // Factor the next y[1] logic for optimization
    wire CE_or = C | E;
    wire BF_or = B | F;
    wire next_y1 = BF_or | (CE_or & w);

    assign Y1 = next_y1;

endmodule