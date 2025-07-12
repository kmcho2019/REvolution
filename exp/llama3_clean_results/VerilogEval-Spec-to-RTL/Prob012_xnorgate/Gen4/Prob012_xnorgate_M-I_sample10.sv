module TopModule(
    input  a,
    input  b,
    output out
);

// Implementing XNOR using basic gates
assign out = (a && b) || (!a && !b);

endmodule