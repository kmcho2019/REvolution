module TopModule (
    input  in1,
    input  in2,
    output out
);
    // NOR implementation using De Morgan's law: NOR(a,b) = NAND(~a,~b)
    wire in1_n, in2_n;
    assign in1_n = ~in1;
    assign in2_n = ~in2;
    assign out = ~(in1_n & in2_n);
endmodule