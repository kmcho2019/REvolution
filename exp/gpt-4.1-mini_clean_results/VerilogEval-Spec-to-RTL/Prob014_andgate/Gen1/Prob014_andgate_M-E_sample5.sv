module TopModule (
    input  a,
    input  b,
    output reg out
);

always @(*) begin
    if (a & b)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule