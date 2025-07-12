module TopModule(
    input  [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // out_both: check if current bit and its left neighbor are both '1'
    assign out_both[3:1] = in[3:1] & in[2:0];
    
    // out_any: check if current bit or its right neighbor is '1'
    assign out_any[2:0] = in[2:0] | {in[1:0], in[3]};
    
    // out_different: check if current bit is different from its left neighbor
    assign out_different[3:0] = in[3:0] ^ {in[0], in[3:1]};

endmodule