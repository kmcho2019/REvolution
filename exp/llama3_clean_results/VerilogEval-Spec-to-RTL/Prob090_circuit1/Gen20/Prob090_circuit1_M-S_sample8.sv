// TopModule: A combinational circuit implementing a logical AND operation
module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always @(*) begin
    q = a & b;
end

endmodule