module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal 2:1 multiplexer implementation
    // Selects 'a' when sel=0, 'b' when sel=1
    // Directly maps to hardware multiplexer primitive
    assign out = sel ? b : a;
endmodule