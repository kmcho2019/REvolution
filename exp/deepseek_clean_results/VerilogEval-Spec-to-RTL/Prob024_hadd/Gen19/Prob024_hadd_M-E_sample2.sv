module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // MUX implementation of sum: when b=0 select a, when b=1 select ~a
    assign sum = b ? ~a : a;
    
    // MUX implementation of carry: when b=0 select 0, when b=1 select a
    assign cout = b ? a : 1'b0;
endmodule