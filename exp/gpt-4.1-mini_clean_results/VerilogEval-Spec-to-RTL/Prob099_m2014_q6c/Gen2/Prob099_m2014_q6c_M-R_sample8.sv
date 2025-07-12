module TopModule(
    input  [5:0] y,  // current state one-hot encoding
    input        w,
    output reg   Y2, // next state bit for y[1] (state B)
    output reg   Y4  // next state bit for y[3] (state D)
);

always @(*) begin
    // Next state bit y[1] (B)
    Y2 = y[0] & (~w);

    // Next state bit y[3] (D)
    Y4 = w & (y[1] | y[2] | y[4] | y[5]);
end

endmodule