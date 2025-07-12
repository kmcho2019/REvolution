module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Implement OR(b,c) using a 2:1 mux
    assign q = b ? 1'b1 : c;

endmodule