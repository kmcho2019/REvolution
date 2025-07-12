module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always @(*) begin
    logic [1:0] sum;
    sum = a + b;
    q = (sum == 2) ? 1'b1 : 1'b0;
end

endmodule