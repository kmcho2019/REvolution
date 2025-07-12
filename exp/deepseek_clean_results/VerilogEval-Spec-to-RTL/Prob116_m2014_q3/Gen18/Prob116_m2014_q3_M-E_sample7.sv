module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map (x[3]=x[4], x[2]=x[3], x[1]=x[2], x[0]=x[1])
    output f
);
    // Implement as a 4:1 mux with x[3] and x[2] as select lines
    wire [3:0] mux_in;
    
    // Row 00: x[3]x[2] = 00
    assign mux_in[0] = (~x[1] & ~x[0]) ? 1'b0 :  // 00 -> 0
                      (~x[1] & x[0]) ? 1'b0 :    // 01 -> 0
                      (x[1] & x[0]) ? 1'b0 :     // 11 -> d (choose 0)
                      1'b0;                      // 10 -> d (choose 0)
    
    // Row 01: x[3]x[2] = 01
    assign mux_in[1] = (~x[1] & ~x[0]) ? 1'b0 :  // 00 -> 0
                      (~x[1] & x[0]) ? 1'b0 :    // 01 -> d (choose 0)
                      (x[1] & x[0]) ? 1'b1 :     // 11 -> 1
                      1'b0;                      // 10 -> 0
    
    // Row 11: x[3]x[2] = 11
    assign mux_in[2] = (~x[1] & ~x[0]) ? 1'b1 :  // 00 -> 1
                      (~x[1] & x[0]) ? 1'b1 :    // 01 -> 1
                      (x[1] & x[0]) ? 1'b0 :     // 11 -> d (choose 0)
                      1'b0;                      // 10 -> d (choose 0)
    
    // Row 10: x[3]x[2] = 10
    assign mux_in[3] = (~x[1] & ~x[0]) ? 1'b1 :  // 00 -> 1
                      (~x[1] & x[0]) ? 1'b1 :    // 01 -> 1
                      (x[1] & x[0]) ? 1'b0 :     // 11 -> 0
                      1'b0;                      // 10 -> d (choose 0)
    
    assign f = mux_in[{x[3], x[2]}];
endmodule