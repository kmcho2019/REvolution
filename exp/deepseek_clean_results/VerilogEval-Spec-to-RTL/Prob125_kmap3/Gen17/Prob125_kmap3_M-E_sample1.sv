module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Hierarchical mux implementation
    wire a0_case;
    
    // Secondary expression for when a=0
    assign a0_case = (~b) & c;
    
    // Primary mux: output 1 when a=1, else use secondary expression
    assign out = a ? 1'b1 : a0_case;
endmodule