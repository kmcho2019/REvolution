module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

reg [9:0] and_group;
reg [9:0] or_group;
reg [9:0] xor_group;

integer i, j;

always @* begin
    // Compute reduction of each group of 10 inputs
    for (i = 0; i < 10; i = i + 1) begin
        and_group[i] = 1'b1;
        or_group[i]  = 1'b0;
        xor_group[i] = 1'b0;
        for (j = 0; j < 10; j = j + 1) begin
            and_group[i] = and_group[i] & in[i*10 + j];
            or_group[i]  = or_group[i] | in[i*10 + j];
            xor_group[i] = xor_group[i] ^ in[i*10 + j];
        end
    end

    // Final reductions over groups
    out_and = &and_group;
    out_or  = |or_group;
    out_xor = ^xor_group;
end

endmodule