module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    // Optimal 2-to-1 multiplexer implementation
    // Selects 'a' when sel=0, 'b' when sel=1
    // Directly maps to single hardware multiplexer
    assign out = sel ? b : a;
endmodule