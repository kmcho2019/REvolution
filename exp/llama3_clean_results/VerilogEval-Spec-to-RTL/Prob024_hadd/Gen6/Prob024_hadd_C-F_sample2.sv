module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

// Using XOR for sum and AND for carry-out as these operations are optimal for a half adder
assign sum = a ^ b;  
assign cout = a & b;  

endmodule