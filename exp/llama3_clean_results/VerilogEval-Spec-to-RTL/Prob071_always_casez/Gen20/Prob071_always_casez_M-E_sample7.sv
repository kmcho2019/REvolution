module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [1:0] msb_match;
    wire [1:0] msb_high;
    wire [2:0] next_pos;

    // Stage 1: Evaluate the most significant half (4 bits)
    assign msb_match = (in[7] || in[6] || in[5] || in[4])? 2'b01 : 2'b00;
    assign msb_high = (in[7] || in[6] || in[5] || in[4])? 2'b10 : 2'b00;

    // Stage 2: Evaluate the next most significant half (2 bits)
    assign next_pos = (msb_match == 2'b01 && msb_high == 2'b10)? 
                     (in[5] || in[4])? 3'd4 : 
                     (in[6] || in[7])? 3'd6 : 3'd0;

    // Stage 3: Evaluate the least significant bits
    assign pos = (next_pos == 3'd4)? 
                (in[3] || in[2] || in[1] || in[0])? 
                (in[3])? 3'd3 : 
                (in[2])? 3'd2 : 
                (in[1])? 3'd1 : 
                (in[0])? 3'd0 : 3'd0 : 
                (next_pos == 3'd6)? 
                (in[7])? 3'd7 : 
                (in[6])? 3'd6 : 
                (in[5])? 3'd5 : 
                (in[4])? 3'd4 : 3'd0 : 3'd0;

endmodule