module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // OR gate to create the mux select signal
    wire sel = b | c;
    
    // 2:1 multiplexer implementation
    assign out = sel ? 1'b1 : a;
endmodule