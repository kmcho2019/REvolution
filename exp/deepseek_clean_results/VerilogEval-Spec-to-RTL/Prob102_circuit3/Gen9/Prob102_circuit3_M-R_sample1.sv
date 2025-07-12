module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [1:0] ab = {a, b};
    wire [1:0] cd = {c, d};
    
    assign q = (|ab) & (|cd);

endmodule