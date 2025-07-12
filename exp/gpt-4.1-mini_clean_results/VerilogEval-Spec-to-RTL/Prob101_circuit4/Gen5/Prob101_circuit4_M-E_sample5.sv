module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Implement q as a 2-to-1 mux:
    // If b=1, output 1, else output c
    assign q = b ? 1'b1 : c;

endmodule