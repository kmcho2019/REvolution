module TopModule(
    input [3:0] x,
    output reg f
);

always @(x) begin
    f = (x[3] | x[2]) & (~x[1] | ~x[0]) | (x[3] & x[2] & x[1] & ~x[0]);
end

endmodule