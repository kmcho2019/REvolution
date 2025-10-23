module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Generate out_both
    assign out_both[3] = 1'b0;
    assign out_both[2:0] = in[2:0] & {in[3], in[2:1]};

    // Generate out_any
    assign out_any[0] = in[0];
    assign out_any[3:1] = {in[3], in[2:1]} | in[3:1];

    // Generate out_different using XOR for simplicity and efficiency
    assign out_different = {in[0] ^ in[3], in[3:1] ^ {in[2:0], in[3]}};

endmodule