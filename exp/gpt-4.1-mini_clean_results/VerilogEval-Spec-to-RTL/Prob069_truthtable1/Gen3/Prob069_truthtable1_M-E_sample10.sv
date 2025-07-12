module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output reg f
);

always @(*) begin
    if (x3 == 1'b0) begin
        if (x2 == 1'b1)
            f = 1'b1;
        else
            f = 1'b0;
    end else begin // x3 == 1
        if (x1 == 1'b1)
            f = 1'b1;
        else
            f = 1'b0;
    end
end

endmodule