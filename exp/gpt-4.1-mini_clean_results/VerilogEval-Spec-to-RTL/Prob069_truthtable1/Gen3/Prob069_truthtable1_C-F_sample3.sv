module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output reg f
);

always @(*) begin
    f = x3 ? x1 : x2;
end

endmodule