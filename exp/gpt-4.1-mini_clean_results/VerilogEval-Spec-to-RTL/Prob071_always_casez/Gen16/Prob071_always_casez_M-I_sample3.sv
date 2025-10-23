module TopModule (
    input  [7:0] in,
    output [2:0] pos
);
    wire [7:0] one_hot;
    wire [2:0] encoded_pos;
    
    // Find one-hot for lowest set bit
    assign one_hot[0] = in[0];
    assign one_hot[1] = ~in[0] & in[1];
    assign one_hot[2] = ~|in[1:0] & in[2];
    assign one_hot[3] = ~|in[2:0] & in[3];
    assign one_hot[4] = ~|in[3:0] & in[4];
    assign one_hot[5] = ~|in[4:0] & in[5];
    assign one_hot[6] = ~|in[5:0] & in[6];
    assign one_hot[7] = ~|in[6:0] & in[7];
    
    // Encode one_hot to binary position
    // If none set, default to zero
    assign encoded_pos =
        (one_hot[0]) ? 3'd0 :
        (one_hot[1]) ? 3'd1 :
        (one_hot[2]) ? 3'd2 :
        (one_hot[3]) ? 3'd3 :
        (one_hot[4]) ? 3'd4 :
        (one_hot[5]) ? 3'd5 :
        (one_hot[6]) ? 3'd6 :
        (one_hot[7]) ? 3'd7 : 3'd0;
    
    assign pos = encoded_pos;

endmodule