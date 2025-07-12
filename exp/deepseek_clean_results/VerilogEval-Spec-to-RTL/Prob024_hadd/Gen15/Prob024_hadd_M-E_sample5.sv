module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Sum is a when b=0, ~a when b=1 (equivalent to XOR)
    assign sum = b ? ~a : a;
    
    // Carry is b when a=1, 0 when a=0 (equivalent to AND)
    assign cout = a ? b : 1'b0;

endmodule