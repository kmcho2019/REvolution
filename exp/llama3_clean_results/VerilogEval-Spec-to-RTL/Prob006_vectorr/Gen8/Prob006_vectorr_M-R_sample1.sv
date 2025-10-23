module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, if you want to use a more general and scalable approach
    // for different sizes of the input vector, you can use a simple for loop
    // within an always block, or more concisely, use the following assignment:
    // assign out = in[7:0];

    // However, note that the above statement directly assigns the bits in the
    // same order, so we actually want the reverse, which can be achieved with:
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule