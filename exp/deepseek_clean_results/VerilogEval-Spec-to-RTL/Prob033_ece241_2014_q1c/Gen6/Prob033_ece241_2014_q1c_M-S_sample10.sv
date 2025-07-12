module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b};
    assign s = sum_ext[7:0];
    assign overflow = sum_ext[8] ^ sum_ext[7];
endmodule