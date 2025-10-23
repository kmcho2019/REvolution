module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output reg f
);

    always @(*) begin
        if (~x3 && x2)
            f = 1'b1;
        else if (x3 && x1)
            f = 1'b1;
        else
            f = 1'b0;
    end

endmodule