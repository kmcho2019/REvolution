module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);

    // Stage 1: 3-bit population counters (85 in total)
    wire [1:0] stage1_counts [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : BIT3_COUNTERS
            assign stage1_counts[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Stage 2: Pipelined accumulation
    reg [9:0] accumulator;  // 10 bits to handle 85*3=255 max count
    integer j;
    always @(*) begin
        accumulator = 0;
        for (j = 0; j < 85; j = j + 1) begin
            accumulator = accumulator + stage1_counts[j];
        end
        out = accumulator[7:0];  // Final 8-bit output
    end

endmodule