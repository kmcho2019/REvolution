module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    
    assign out = (~b & ~c & ~d) | (~b & c & d) | (a & ~c & ~d) | (a & c & ~d);
    
endmodule