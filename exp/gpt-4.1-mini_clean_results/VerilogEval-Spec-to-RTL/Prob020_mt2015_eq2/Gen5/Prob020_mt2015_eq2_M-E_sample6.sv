module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [2:0] diff;
assign diff = {1'b0, A} - {1'b0, B};
assign z = (diff == 3'd0);

endmodule