module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    wire sum_intermediate;
    
    assign sum_intermediate = a ^ b;
    assign sum = sum_intermediate;
    assign cout = a & b;
endmodule