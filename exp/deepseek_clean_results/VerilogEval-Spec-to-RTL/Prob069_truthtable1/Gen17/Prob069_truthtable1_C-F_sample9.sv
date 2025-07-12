module TopModule (
    input x3,
    input x2,
    input x1,
    output reg f
);
    always @(*) begin
        if (x3)
            f = x1;
        else
            f = x2;
    end
endmodule