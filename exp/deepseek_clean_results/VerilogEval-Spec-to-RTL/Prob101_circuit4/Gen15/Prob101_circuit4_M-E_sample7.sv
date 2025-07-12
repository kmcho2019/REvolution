module TopModule (input a, b, c, d, output q);
    // Implement b OR c using a 4:1 mux
    // Select lines: b and c
    // Data inputs configured for OR function:
    // 00: 0
    // 01: 1 (c=1)
    // 10: 1 (b=1)
    // 11: 1 (b or c=1)
    assign q = (b == 0 && c == 0) ? 1'b0 :
               (b == 0 && c == 1) ? 1'b1 :
               (b == 1 && c == 0) ? 1'b1 :
               1'b1;
endmodule