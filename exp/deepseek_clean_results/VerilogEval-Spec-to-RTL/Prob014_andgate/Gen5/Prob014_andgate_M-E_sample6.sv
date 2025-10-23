module TopModule(
    input a,
    input b,
    output out
);
    // Implement AND gate as a 4:1 mux (LUT-style)
    // Input combinations:
    // 00 -> 0
    // 01 -> 0
    // 10 -> 0
    // 11 -> 1
    assign out = (a & b) ? 1'b1 : 1'b0;
endmodule