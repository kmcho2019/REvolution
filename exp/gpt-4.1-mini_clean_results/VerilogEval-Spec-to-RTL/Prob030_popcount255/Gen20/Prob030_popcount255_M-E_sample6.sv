module recursive_popcount #(
    parameter integer N = 1
) (
    input  wire [N-1:0] bits_in,
    output wire [$clog2(N+1)-1:0] count_out
);
    // Base case: if only one bit, output is that bit zero-extended
    generate
        if (N == 1) begin
            assign count_out = bits_in;
        end else begin
            // Recursive case: split inputs roughly in half
            localparam integer N_left = N / 2;
            localparam integer N_right = N - N_left;

            wire [$clog2(N_left+1)-1:0] left_count;
            wire [$clog2(N_right+1)-1:0] right_count;

            recursive_popcount #(N_left) left_inst (
                .bits_in(bits_in[N_left-1:0]),
                .count_out(left_count)
            );

            recursive_popcount #(N_right) right_inst (
                .bits_in(bits_in[N-1:N_left]),
                .count_out(right_count)
            );

            // Add left_count and right_count
            // Output width must cover max possible sum = N_left + N_right = N
            // count_out width is ceil(log2(N+1))
            assign count_out = left_count + right_count;
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]  out
);

    // Instantiate recursive_popcount for 255 bits
    // Output width is 8 bits (since log2(256) = 8)
    wire [7:0] popcnt;

    recursive_popcount #(
        .N(255)
    ) popcnt_inst (
        .bits_in(in),
        .count_out(popcnt)
    );

    assign out = popcnt;

endmodule