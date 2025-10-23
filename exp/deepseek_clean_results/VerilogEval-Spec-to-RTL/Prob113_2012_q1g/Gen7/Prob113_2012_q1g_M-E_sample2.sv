module TopModule(
    input [3:0] x,
    output f
);
    wire [3:0] decoder_out;
    
    // 2-to-4 decoder for x[3:2]
    assign decoder_out[0] = ~x[3] & ~x[2];  // 00
    assign decoder_out[1] = ~x[3] & x[2];   // 01
    assign decoder_out[2] = x[3] & x[2];     // 11
    assign decoder_out[3] = x[3] & ~x[2];    // 10
    
    // Logic for each decoded case
    wire f_00 = decoder_out[0] & (~x[1] | ~x[0]);  // 0000, 0010
    wire f_01 = 1'b0;                              // Always 0 for 01xx
    wire f_11 = decoder_out[2] & (x[1] | ~x[0]);   // 1100, 1101, 1111
    wire f_10 = decoder_out[3] & (~x[1] | x[0]);   // 1000, 1001, 1010
    
    assign f = f_00 | f_01 | f_11 | f_10;
endmodule