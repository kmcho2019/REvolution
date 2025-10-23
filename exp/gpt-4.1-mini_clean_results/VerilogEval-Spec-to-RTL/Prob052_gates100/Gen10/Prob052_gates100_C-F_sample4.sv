module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

    reg [9:0] and_group;
    reg [9:0] or_group;
    reg [9:0] xor_group;
    integer i;

    always @(*) begin
        // Compute group-level reductions using built-in reduction operators for efficiency
        for (i = 0; i < 10; i = i + 1) begin
            and_group[i] = &in[i*10 +: 10];  // 10-bit slice reduction AND
            or_group[i]  = |in[i*10 +: 10];  // 10-bit slice reduction OR
            xor_group[i] = ^in[i*10 +: 10];  // 10-bit slice reduction XOR
        end

        // Combine group results using reduction operators for final output
        out_and = &and_group;
        out_or  = |or_group;
        out_xor = ^xor_group;
    end

endmodule