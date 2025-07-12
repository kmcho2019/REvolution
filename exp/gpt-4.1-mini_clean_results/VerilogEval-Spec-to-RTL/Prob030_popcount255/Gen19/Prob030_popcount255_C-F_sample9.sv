module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits for sum up to 17
);
    // Level 1: sum pairs of bits (2-bit results)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit values (3-bit results)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit values (4-bit results)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit values (5-bit result)
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit, final 6-bit output
    assign out = s14 + leftover;
endmodule

module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive balanced popcount with popcount17 base case for WIDTH <= 17
    generate
        if (WIDTH <= 17) begin : base_case
            // Zero-pad input if WIDTH < 17 for popcount17
            wire [16:0] base_in = { {(17-WIDTH){1'b0}}, in };
            popcount17 u_popcount17 (
                .in(base_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            // Compute bit widths for left and right sums
            localparam left_out_width = $clog2(half+1);
            localparam right_out_width = $clog2(right_width+1);
            localparam sum_width = $clog2(WIDTH+1);

            wire [left_out_width-1:0] left_sum;
            wire [right_out_width-1:0] right_sum;

            popcount #(.WIDTH(half)) left_popcount (
                .in(in[half-1:0]),
                .out(left_sum)
            );

            popcount #(.WIDTH(right_width)) right_popcount (
                .in(in[WIDTH-1:half]),
                .out(right_sum)
            );

            // Extend operands to sum_width bits and add
            assign out = {{(sum_width-left_out_width){1'b0}}, left_sum} + {{(sum_width-right_out_width){1'b0}}, right_sum};
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate recursive popcount with popcount17 base case for 255 bits
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule