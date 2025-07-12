module TopModule(
    input  a,
    input  b,
    output out
);

    // Compute the out signal using basic logic gates
    assign out = (a && b) || (!a && !b);

endmodule