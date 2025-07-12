module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones fits in 5 bits but 6 bits for margin
);
    // Sum individual bits by progressive accumulation in a single vector
    integer i;
    reg [5:0] count;
    always @(*) begin
        count = 0;
        for (i = 0; i < 17; i = i + 1) begin
            count = count + in[i];
        end
    end
    assign out = count;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [0:14];

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc_inst (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Flatten sum: accumulate all partial_counts into a single 8-bit sum wire
    integer j;
    reg [7:0] total_count;
    always @(*) begin
        total_count = 0;
        for (j = 0; j < 15; j = j + 1) begin
            total_count = total_count + partial_counts[j];
        end
    end

    assign out = total_count;

endmodule