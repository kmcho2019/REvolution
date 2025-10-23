module TopModule(
    input  a,
    input  b,
    output out
);

    // Alternative XNOR implementation using AND, OR, and NOT
    assign out = (a && b) || (!a && !b);

endmodule