module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Create a mask that propagates the first '1' to all higher bits
wire [7:0] mask = in | (in & (in - 1)) | (in & (in - 1) & (in - 2)) |
                 (in & (in - 1) & (in - 2) & (in - 3)) |
                 (in & (in - 1) & (in - 2) & (in - 3) & (in - 4)) |
                 (in & (in - 1) & (in - 2) & (in - 3) & (in - 4) & (in - 5)) |
                 (in & (in - 1) & (in - 2) & (in - 3) & (in - 4) & (in - 5) & (in - 6));

// Isolate the first set bit by XORing with shifted mask
wire [7:0] one_hot = mask ^ {mask[6:0], 1'b0};

// Convert one-hot to binary
assign pos = one_hot[0] ? 3'd0 :
             one_hot[1] ? 3'd1 :
             one_hot[2] ? 3'd2 :
             one_hot[3] ? 3'd3 :
             one_hot[4] ? 3'd4 :
             one_hot[5] ? 3'd5 :
             one_hot[6] ? 3'd6 :
             one_hot[7] ? 3'd7 : 3'd0;

endmodule