module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Using constants to simplify the logic
    assign out_both[3] = 1'b0;
    assign out_both[2:0] = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // Using more concise syntax for out_any
    assign out_any[0] = in[0];
    assign out_any[3:1] = {in[3] | in[2], in[2] | in[1], in[1] | in[0]};

    // Keeping the XOR operator for out_different as it's already efficient
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule