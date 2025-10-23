module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount_power2 #(
    parameter WIDTH = 256  // WIDTH must be a power of two, >=8
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive balanced popcount for power-of-two widths with base case at WIDTH=8 using popcount8

    generate
        if (WIDTH == 8) begin : base_case
            popcount8 u_popcount8 (
                .in(in),
                .out(out)
            );
        end else begin : recursive_case
            localparam HALF = WIDTH / 2;
            wire [$clog2(HALF+1)-1:0] left_count;
            wire [$clog2(HALF+1)-1:0] right_count;

            popcount_power2 #(.WIDTH(HALF)) left_popcount (
                .in(in[HALF-1:0]),
                .out(left_count)
            );

            popcount_power2 #(.WIDTH(HALF)) right_popcount (
                .in(in[WIDTH-1:HALF]),
                .out(right_count)
            );

            // Sum left and right counts.  
            // Both have bitwidth $clog2(HALF+1), so sum fits in $clog2(WIDTH+1).
            assign out = left_count + right_count;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad 255-bit input to 256 bits by adding one zero MSB bit
    wire [255:0] in_padded = {1'b0, in};

    wire [8:0] popcount_9bit; // max 256 ones needs 9 bits

    // Recursive popcount with power-of-two WIDTH=256, using structural popcount8 base
    popcount_power2 #(.WIDTH(256)) u_popcount (
        .in(in_padded),
        .out(popcount_9bit)
    );

    // Output trimmed to 8 bits since max is 255, upper bit always zero
    assign out = popcount_9bit[7:0];
endmodule