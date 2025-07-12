module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    // Alternatively, a more concise way to achieve the same result:
    // assign out = in[7:0];

    // However, considering we want to explicitly reverse the bits,
    // we can use the following expression which is more straightforward:
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule