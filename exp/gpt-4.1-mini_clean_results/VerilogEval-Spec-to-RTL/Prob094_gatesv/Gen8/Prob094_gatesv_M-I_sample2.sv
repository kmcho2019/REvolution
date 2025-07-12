module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // For out_both: left neighbor for bit i is in[i+1], but in[4] doesn't exist, pad with 0
    wire [4:0] in_both = {in, 1'b0}; // in_both[4] = 0
    assign out_both = in & in_both[4:1]; // out_both[3] = in[3] & 0 = 0 implicitly

    // For out_any: right neighbor for bit i is in[i-1], but in[-1] doesn't exist, pad with 0
    wire [4:0] in_any = {1'b0, in}; // in_any[0] = 0
    assign out_any = in | in_any[3:0]; // out_any[0] = in[0] | 0 = in[0] (but spec says no need for out_any[0])

    // The spec says out_any[0] is irrelevant (does not need to be known), so we zero it explicitly:
    assign out_any[0] = 1'b0;

    // wrap-around XOR for out_different (neighbor to left with wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule