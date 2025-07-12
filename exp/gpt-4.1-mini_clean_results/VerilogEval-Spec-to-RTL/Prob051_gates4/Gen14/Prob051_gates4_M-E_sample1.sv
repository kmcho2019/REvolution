module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // out_and: check if all bits of input are 1 by comparing to 4'b1111
    assign out_and = (in == 4'b1111);

    // out_or: check if any bit is 1 by comparing input to zero
    assign out_or = (in != 4'b0000);

    // out_xor: compute parity of input bits by XORing all bits at once
    assign out_xor = ^in; // bitwise XOR reduction operator for parity

endmodule