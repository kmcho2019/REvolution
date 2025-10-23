module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal 2:1 mux implementation - maps directly to hardware multiplexer
    // When sel=0: out = a
    // When sel=1: out = b
    assign out = sel ? b : a;
endmodule