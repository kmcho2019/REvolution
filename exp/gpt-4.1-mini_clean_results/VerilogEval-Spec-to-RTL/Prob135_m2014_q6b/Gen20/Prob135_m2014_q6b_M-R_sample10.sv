module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        next_y1 = (y[0] & ~y[1]) | ((~y[0]) & w & (y[1] | y[2]));
    end

    assign Y1 = y[1];

endmodule