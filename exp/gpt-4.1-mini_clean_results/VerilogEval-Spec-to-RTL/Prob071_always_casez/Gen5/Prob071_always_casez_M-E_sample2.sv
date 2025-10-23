module TopModule(
    input  [7:0] in,
    output [2:0] pos
);
    wire [7:0] one_hot;

    // Generate one_hot signal: one_hot[i] is 1 iff in[i] is set and no lower bit is set
    assign one_hot = in & ~(in - 1);

    // Encode the one_hot signal to binary index
    // If no bits are set (one_hot == 0), pos = 0
    assign pos = one_hot[0] ? 3'd0 :
                 one_hot[1] ? 3'd1 :
                 one_hot[2] ? 3'd2 :
                 one_hot[3] ? 3'd3 :
                 one_hot[4] ? 3'd4 :
                 one_hot[5] ? 3'd5 :
                 one_hot[6] ? 3'd6 :
                 one_hot[7] ? 3'd7 :
                 3'd0;  // no bits set

endmodule