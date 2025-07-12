module TopModule (
    input a,
    input b,
    output q
);
    // Implement AND gate using 2:1 mux
    assign q = b ? a : 1'b0;
endmodule