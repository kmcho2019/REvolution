module TopModule (
    input  a,
    input  b,
    output reg out
);

    always @ (a or b) begin
        if (a == 1'b1 || b == 1'b1)
            out = 1'b0;
        else
            out = 1'b1;
    end

endmodule