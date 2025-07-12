module TopModule(
    input [3:0] x,
    output f
);
    wire [3:0] dec_high;  // Decoder for x[3:2]
    wire [3:0] dec_low;   // Decoder for x[1:0]
    
    // 2-to-4 decoder for x[3:2]
    assign dec_high[0] = ~x[3] & ~x[2];  // 00
    assign dec_high[1] = ~x[3] &  x[2];  // 01
    assign dec_high[2] =  x[3] &  x[2];  // 11
    assign dec_high[3] =  x[3] & ~x[2];  // 10
    
    // 2-to-4 decoder for x[1:0]
    assign dec_low[0] = ~x[1] & ~x[0];   // 00
    assign dec_low[1] = ~x[1] &  x[0];   // 01
    assign dec_low[2] =  x[1] &  x[0];   // 11
    assign dec_low[3] =  x[1] & ~x[0];   // 10
    
    // Implement K-map logic
    assign f = (dec_high[0] & (dec_low[0] | dec_low[3])) |  // 00 with 00 or 10
               (dec_high[2] & ~dec_low[3]) |                 // 11 except 10
               (dec_high[3] & ~dec_low[2]);                 // 10 except 11
endmodule