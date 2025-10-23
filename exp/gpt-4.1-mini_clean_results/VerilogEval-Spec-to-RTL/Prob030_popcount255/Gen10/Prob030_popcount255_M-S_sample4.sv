module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Number of full 8-bit chunks and remainder bits
    localparam FULL_CHUNKS = 31;
    localparam REM_BITS = 7;

    // Function to count bits in a small vector using '+' operator on bits
    // Synthesizes to efficient adders
    function [3:0] popcount8;
        input [7:0] bits;
        integer i;
        begin
            popcount8 = 0;
            for (i = 0; i < 8; i = i + 1) begin
                popcount8 = popcount8 + bits[i];
            end
        end
    endfunction

    // Function to count bits in up to 7 bits
    function [3:0] popcount7;
        input [6:0] bits;
        integer i;
        begin
            popcount7 = 0;
            for (i = 0; i < 7; i = i + 1) begin
                popcount7 = popcount7 + bits[i];
            end
        end
    endfunction

    // Array to hold partial population counts from 8-bit chunks
    wire [3:0] partial_counts [0:FULL_CHUNKS-1];

    genvar idx;
    generate
        for (idx = 0; idx < FULL_CHUNKS; idx = idx + 1) begin : pop8chunks
            assign partial_counts[idx] = popcount8(in[8*idx +: 8]);
        end
    endgenerate

    // Partial count for remaining 7 bits
    wire [3:0] last_count = popcount7(in[254:8*FULL_CHUNKS]);

    // Sum all partial counts (31 * 4-bit + 4-bit)
    // Max sum = 255, fits in 8 bits
    // Use a simple adder tree using a reduction loop

    // Flatten partial counts and last count into one array of 32 elements
    wire [4:0] sums[0:31];
    assign sums[31] = last_count;  // 4 bits can extend to 5 bits for sum safety

    generate
        for (idx = 0; idx < FULL_CHUNKS; idx = idx + 1) begin : widen_partial
            assign sums[idx] = {1'b0, partial_counts[idx]}; // zero-extend to 5 bits
        end
    endgenerate

    // Add all sums in a simple combinational way
    // Since the input size is fixed and small, a for loop summation in always_comb

    reg [12:0] total_sum; // 5 bits * 32 max sum <= 13 bits safe

    integer j;
    always @(*) begin
        total_sum = 0;
        for (j = 0; j < 32; j = j + 1) begin
            total_sum = total_sum + sums[j];
        end
    end

    // Output lower 8 bits (max 255)
    assign out = total_sum[7:0];

endmodule