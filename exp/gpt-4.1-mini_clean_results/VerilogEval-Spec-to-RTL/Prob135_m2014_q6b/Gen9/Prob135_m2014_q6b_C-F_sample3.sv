module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states based on given encoding
    wire B = (~y[2]) & (~y[1]) &  y[0];  // 001
    wire C = (~y[2]) &  y[1]  & ~y[0];  // 010
    wire E =  y[2]  & (~y[1]) & ~y[0];  // 100
    wire F =  y[2]  & (~y[1]) &  y[0];  // 101

    // Next y[1] combinational logic
    wire next_y1 = B | (C & w) | (E & w) | F;

    assign Y1 = next_y1;

endmodule