module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

// Partition inputs into 10 groups of 10 bits each
wire [9:0] and_group;
wire [9:0] or_group;
wire [9:0] xor_group;

genvar i;
generate
    for (i = 0; i < 10; i = i + 1) begin : group_reduce
        assign and_group[i] = &in[i*10 +: 10];
        assign or_group[i]  = |in[i*10 +: 10];
        assign xor_group[i] = ^in[i*10 +: 10];
    end
endgenerate

// Combine intermediate results
assign out_and = &and_group;
assign out_or  = |or_group;
assign out_xor = ^xor_group;

endmodule