module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    reg f1, f2, f3;
    f1 = x[3] & x[2];
    f2 = x[3] & ~x[1];
    f3 = x[2] & x[1];
    f = f1 | f2 | f3;
end

endmodule