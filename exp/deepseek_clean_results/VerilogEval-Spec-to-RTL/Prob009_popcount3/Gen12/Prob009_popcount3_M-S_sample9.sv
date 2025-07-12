module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = ^in;               // XOR all bits for parity/LSB
    assign out[1] = |(in & 3'b011) &&  // At least two bits are 1
                   (|in);              // And at least one bit is 1 (redundant but clearer)
endmodule