module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // B or F: y[1]=0 & y[0]=1; C or E: (y==010 or 100)
    wire BF = ~y[1] & y[0];
    wire CE = (y == 3'b010) | (y == 3'b100);

    assign Y1 = BF | (CE & w);

endmodule