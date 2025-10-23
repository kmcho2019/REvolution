module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] diff;
assign diff = A ^ B;
assign z = &~diff;

endmodule