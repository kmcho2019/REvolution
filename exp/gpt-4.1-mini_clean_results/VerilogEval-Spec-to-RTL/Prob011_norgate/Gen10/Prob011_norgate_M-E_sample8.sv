module TopModule (
    input  a,
    input  b,
    output reg out
);

    always @(*) begin
        if (a == 1'b0 && b == 1'b0)
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule