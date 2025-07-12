module TopModule (
    input  [3:0] x,
    output reg  f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    always @(*) begin
        if (x3 & ~x1)
            f = 1'b1;
        else if (~x3 & x0 & x1 & x2)
            f = 1'b1;
        else
            f = 1'b0;
    end

endmodule