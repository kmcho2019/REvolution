// Direct implementation of half adder within a single module
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;
assign cout = a & b;
endmodule