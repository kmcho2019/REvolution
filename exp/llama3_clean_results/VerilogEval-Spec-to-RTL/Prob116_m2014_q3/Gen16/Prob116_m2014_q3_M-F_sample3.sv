module TopModule(
    input [3:0] x,
    output logic f
);

always @(*) begin
    f = x[3] & (x[1] | x[2]);
end

endmodule