module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg next_y1;

    always @(*) begin
        next_y1 = (~y1 & y0) | (w & ((y1 | y2) & ~y0));
    end

    assign Y1 = next_y1;

endmodule