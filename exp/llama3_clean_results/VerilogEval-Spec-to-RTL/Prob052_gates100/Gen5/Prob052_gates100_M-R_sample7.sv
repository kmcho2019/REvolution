module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [19:0] and_chunk;
    reg [19:0] or_chunk;
    reg [19:0] xor_chunk;

    integer i;
    always @(*) begin
        for (i = 0; i < 20; i = i + 1) begin
            and_chunk[i] = &in[(i * 5) + 4 : i * 5];
            or_chunk[i] = |in[(i * 5) + 4 : i * 5];
            xor_chunk[i] = ^in[(i * 5) + 4 : i * 5];
        end
        out_and = &and_chunk;
        out_or = |or_chunk;
        out_xor = ^xor_chunk;
    end

endmodule