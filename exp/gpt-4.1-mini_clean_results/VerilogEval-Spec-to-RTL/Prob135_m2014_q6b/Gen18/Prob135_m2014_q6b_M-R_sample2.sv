module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    always @(*) begin
        // Implement next state logic for y[1]
        Y1 = (y[0] & ~y[1]) | ((~y[0]) & w & (y[1] | y[2]));
    end

endmodule