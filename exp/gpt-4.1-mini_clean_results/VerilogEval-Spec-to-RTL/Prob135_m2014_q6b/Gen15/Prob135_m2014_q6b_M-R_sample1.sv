module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    always @(*) begin
        if ((y0 & ~y1) | (~y0 & w & (y1 | y2)))
            Y1 = 1'b1;
        else
            Y1 = 1'b0;
    end

endmodule