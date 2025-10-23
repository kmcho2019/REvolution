module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Next state input to flip-flop y[1] (state B): from A on w=1
        Y1 = y[0] & w;

        // Next state input to flip-flop y[3] (state D): from B,C,E,F on w=0
        Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule