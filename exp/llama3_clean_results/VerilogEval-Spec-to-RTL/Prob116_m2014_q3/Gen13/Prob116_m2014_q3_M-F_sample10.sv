module TopModule(
    input [3:0] x,
    output logic f
);

always @(*) begin
    f = (x[3] & x[2]) | (x[3] & x[1] & ~x[2]) | (x[1] & x[2] & x[0]) | (x[3] & ~x[2] & ~x[1]);
end

endmodule