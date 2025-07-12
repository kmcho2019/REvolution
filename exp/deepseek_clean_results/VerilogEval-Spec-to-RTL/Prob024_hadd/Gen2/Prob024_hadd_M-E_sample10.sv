module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output: when b=0, pass a; when b=1, pass ~a
    assign sum = b ? ~a : a;
    
    // Carry output: only 1 when both inputs are 1
    assign cout = a & b;
endmodule