module TopModule(
    input  a,
    input  b,
    output q
);

    // Implement the AND gate functionality using a multiplexer.
    assign q = (a == 1'b0)? 1'b0 : b;

endmodule