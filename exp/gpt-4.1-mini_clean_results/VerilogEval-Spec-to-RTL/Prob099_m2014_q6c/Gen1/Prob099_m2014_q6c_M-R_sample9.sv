module TopModule(
    input  [5:0] y,   // current state one-hot encoding
    input        w,
    output reg   Y2,  // next state bit corresponding to y[1]
    output reg   Y4   // next state bit corresponding to y[3]
);

always @(*) begin
    Y2 = y[0] & (~w);
    Y4 = w & (y[1] | y[2] | y[4] | y[5]);
end

endmodule