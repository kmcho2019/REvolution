module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Y1 is next state input for y[1]: active when current state is A (y[0]) and w=1
        Y1 = y[0] & w;

        // Y3 is next state input for y[3]: active when w=0 and current state is neither A(y[0]) nor D(y[3])
        // Simplified as (~w) & ~(y[0] | y[3])
        Y3 = (~w) & ~(y[0] | y[3]);
    end

endmodule