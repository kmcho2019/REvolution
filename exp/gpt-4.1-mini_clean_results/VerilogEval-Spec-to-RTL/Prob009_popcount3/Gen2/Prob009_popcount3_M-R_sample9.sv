module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] b0 = {1'b0, in[0]};
    wire [1:0] b1 = {1'b0, in[1]};
    wire [1:0] b2 = {1'b0, in[2]};

    assign out = b0 + b1 + b2;

endmodule