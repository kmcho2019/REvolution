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

    always @* begin
        // Compute reductions over each group of 10 inputs using built-in reduction operators
        for (i = 0; i < 10; i = i + 1) begin
            and_group[i] = &in[i*10 +: 10];
            or_group[i]  = |in[i*10 +: 10];
            xor_group[i] = ^in[i*10 +: 10];
        end

        // Final reductions over groups using built-in operators for minimal logic depth
        out_and = &and_group;
        out_or  = |or_group;
        out_xor = ^xor_group;
    end

endmodule