module popcount2(
    input [1:0] in,
    output [2:0] out
);
    // sum of 2 bits fits in 2 bits, 3 bits width for margin
    assign out = in[0] + in[1];
endmodule

module popcount3(
    input [2:0] in,
    output [2:0] out
);
    // sum of 3 bits fits in 2 bits, 3 bits width for margin
    assign out = in[0] + in[1] + in[2];
endmodule

module popcount_generic #(
    parameter WIDTH = 1
) (
    input [WIDTH-1:0] in,
    output reg [clog2(WIDTH+1)-1:0] out
);
    // Recursive popcount by splitting input into halves and summing partial counts

    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    // Base cases handled explicitly for small WIDTH
    generate
        if (WIDTH == 1) begin : base1
            always @(*) out = in;
        end else if (WIDTH == 2) begin : base2
            wire [2:0] sum2;
            popcount2 pc2(.in(in), .out(sum2));
            always @(*) out = sum2[clog2(WIDTH+1)-1:0];
        end else if (WIDTH == 3) begin : base3
            wire [2:0] sum3;
            popcount3 pc3(.in(in), .out(sum3));
            always @(*) out = sum3[clog2(WIDTH+1)-1:0];
        end else begin : recursive
            localparam L1 = WIDTH / 2;
            localparam L2 = WIDTH - L1;
            wire [clog2(L1+1)-1:0] left_count;
            wire [clog2(L2+1)-1:0] right_count;
            popcount_generic #(L1) left_popcount (.in(in[L1-1:0]), .out(left_count));
            popcount_generic #(L2) right_popcount (.in(in[WIDTH-1:L1]), .out(right_count));

            // Sum partial counts
            wire [clog2(WIDTH+1)-1:0] sum;
            assign sum = left_count + right_count;
            always @(*) out = sum;
        end
    endgenerate
endmodule

module TopModule(
    input [254:0] in,
    output [7:0] out
);
    // Partition input into 5 groups of 51 bits (5*51=255)
    wire [5:0] partial_counts [4:0]; // 6 bits because max 51 ones fits in 6 bits (max 51 decimal)

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : pc51_blocks
            popcount_generic #(51) pc51(.in(in[i*51 +: 51]), .out(partial_counts[i]));
        end
    endgenerate

    // Sum partial counts in 3-stage balanced adder tree
    wire [7:0] sum01 = partial_counts[0] + partial_counts[1]; // sum of two 6-bit numbers fits in 7 bits
    wire [7:0] sum23 = partial_counts[2] + partial_counts[3]; // sum of two 6-bit numbers fits in 7 bits
    wire [7:0] sum0123 = sum01 + sum23;                      // sum of two 7-bit numbers fits in 8 bits
    wire [7:0] sum_final = sum0123 + partial_counts[4];     // sum with last 6-bit partial count

    assign out = sum_final;

endmodule