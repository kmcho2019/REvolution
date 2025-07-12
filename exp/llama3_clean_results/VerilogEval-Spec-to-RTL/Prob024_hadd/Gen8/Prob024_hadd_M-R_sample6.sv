module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
always @(*) begin
    sum = a ^ b;
    cout = a & b;
end
endmodule