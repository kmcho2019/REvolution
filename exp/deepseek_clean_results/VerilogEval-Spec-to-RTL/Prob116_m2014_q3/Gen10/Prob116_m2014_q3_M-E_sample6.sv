module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Implement as 4:1 mux with select lines x[1:0]
    assign f = (x[1:0] == 2'b00) ? (x[3] | x[2]) :  // Column 00: d,0,1,1 -> OR is safe choice
               (x[1:0] == 2'b01) ? (~x[3] & ~x[2]) : // Column 01: 0,d,1,1 -> AND of complements
               (x[1:0] == 2'b10) ? (x[3] & ~x[2]) : // Column 10: d,0,d,d -> AND with complement
                                    (x[3] | ~x[2]);  // Column 11: d,1,d,0 -> OR with complement
endmodule