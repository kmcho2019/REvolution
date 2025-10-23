module popcount4 (
    input  [3:0] in,
    output [2:0] out // max 4 ones fits in 3 bits
);
    // Sum of 4 bits
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones fits in 5 bits; use 6 bits for margin
);
    wire [2:0] sum0, sum1, sum2, sum3;
    wire       sum4;

    // Use popcount4 modules for first 16 bits, then add 1 last bit
    popcount4 pc0 (.in(in[3:0]),    .out(sum0));
    popcount4 pc1 (.in(in[7:4]),    .out(sum1));
    popcount4 pc2 (.in(in[11:8]),   .out(sum2));
    popcount4 pc3 (.in(in[15:12]),  .out(sum3));
    assign sum4 = in[16];

    wire [3:0] sum01 = sum0 + sum1; // max 8, fits 4 bits
    wire [3:0] sum23 = sum2 + sum3; // max 8, fits 4 bits

    wire [4:0] sum0123 = sum01 + sum23; // max 16, fits 5 bits

    assign out = sum0123 + sum4; // max 17, fits 6 bits
endmodule

// Merge two popcount outputs with width N and M bits into sum with width max(N,M)+1
// Here we merge two inputs of equal width W bits, produce output W+1 bits
// Used for merging partial popcount sums in a balanced tree
module popcount2N #(parameter WIDTH = 6) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH:0]   out
);
    assign out = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // 15 groups of 17 bits each
    wire [5:0] pc17_out [14:0];

    // Instantiate 15 popcount17 units
    // Explicit instantiation to aid synthesis clarity and timing
    popcount17 pc0  (.in(in[  0 +:17]), .out(pc17_out[ 0]));
    popcount17 pc1  (.in(in[ 17 +:17]), .out(pc17_out[ 1]));
    popcount17 pc2  (.in(in[ 34 +:17]), .out(pc17_out[ 2]));
    popcount17 pc3  (.in(in[ 51 +:17]), .out(pc17_out[ 3]));
    popcount17 pc4  (.in(in[ 68 +:17]), .out(pc17_out[ 4]));
    popcount17 pc5  (.in(in[ 85 +:17]), .out(pc17_out[ 5]));
    popcount17 pc6  (.in(in[102 +:17]), .out(pc17_out[ 6]));
    popcount17 pc7  (.in(in[119 +:17]), .out(pc17_out[ 7]));
    popcount17 pc8  (.in(in[136 +:17]), .out(pc17_out[ 8]));
    popcount17 pc9  (.in(in[153 +:17]), .out(pc17_out[ 9]));
    popcount17 pc10 (.in(in[170 +:17]), .out(pc17_out[10]));
    popcount17 pc11 (.in(in[187 +:17]), .out(pc17_out[11]));
    popcount17 pc12 (.in(in[204 +:17]), .out(pc17_out[12]));
    popcount17 pc13 (.in(in[221 +:17]), .out(pc17_out[13]));
    popcount17 pc14 (.in(in[238 +:17]), .out(pc17_out[14]));

    // Level 1: merge pairs (width 6 bits input, output 7 bits)
    wire [6:0] level1 [7:0];
    genvar i;
    generate
        for (i=0; i<7; i=i+1) begin: gen_level1
            popcount2N #(6) merge (
                .a(pc17_out[2*i]),
                .b(pc17_out[2*i+1]),
                .out(level1[i])
            );
        end
    endgenerate
    // The 15th input has no pair, zero-extend to 7 bits
    assign level1[7] = {1'b0, pc17_out[14]};

    // Level 2: merge pairs (width 7 bits input, output 8 bits)
    wire [7:0] level2 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin: gen_level2
            popcount2N #(7) merge (
                .a(level1[2*i]),
                .b(level1[2*i+1]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: merge pairs (width 8 bits input, output 9 bits)
    wire [8:0] level3 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin: gen_level3
            popcount2N #(8) merge (
                .a(level2[2*i]),
                .b(level2[2*i+1]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4: final merge (width 9 bits input, output 10 bits)
    wire [9:0] level4_out;
    popcount2N #(9) final_merge (
        .a(level3[0]),
        .b(level3[1]),
        .out(level4_out)
    );

    // Final output is 10 bits wide, max 255 ones = 8 bits needed, so truncate upper bits safely
    assign out = level4_out[7:0];

endmodule