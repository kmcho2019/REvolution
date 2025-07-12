module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Structural implementation using two 2-input OR gates
    wire or_ab;
    
    assign or_ab = a | b;
    assign out = or_ab | c;
endmodule