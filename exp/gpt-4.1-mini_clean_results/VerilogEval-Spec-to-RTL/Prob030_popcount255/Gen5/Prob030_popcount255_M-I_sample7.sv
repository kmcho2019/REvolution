module popcount4 (
    input  [3:0] in,
    output [2:0] out // max 4 ones fits in 3 bits
);
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount3 (
    input  [2:0] in,
    output [2:0] out // max 3 ones fits in 2 bits, use 3 bits for margin
);
    assign out = in[0] + in[1] + in[2];
endmodule

module popcount2 (
    input  [1:0] in,
    output [1:0] out // max 2 ones fits in 2 bits
);
    assign out = in[0] + in[1];
endmodule

// popcount7 implemented by splitting into popcount4 and popcount3
module popcount7 (
    input  [6:0] in,
    output [3:0] out // max 7 ones fits in 3 bits, use 4 bits for margin
);
    wire [2:0] pc4_out;
    wire [2:0] pc3_out;
    wire [3:0] sum;

    popcount4 pc4 (.in(in[3:0]), .out(pc4_out));
    popcount3 pc3 (.in(in[6:4]), .out(pc3_out));
    assign sum = pc4_out + pc3_out; // 3+3 bit add, sum max 7 fits 4 bits
    assign out = sum;
endmodule

// popcount8 implemented as two popcount4 then add
module popcount8 (
    input  [7:0] in,
    output [4:0] out // max 8 ones fits in 4 bits, use 5 bits for margin
);
    wire [2:0] pc4_low, pc4_high;
    wire [4:0] sum;

    popcount4 pc4_low (.in(in[3:0]), .out(pc4_low));
    popcount4 pc4_high(.in(in[7:4]), .out(pc4_high));
    assign sum = pc4_low + pc4_high; // sum max 8 fits 5 bits
    assign out = sum;
endmodule

// Add two N-bit inputs, output N+1 bits sum
module adder #(parameter WIDTH=5) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH:0]   sum
);
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // Partition input: 8 groups of 8 bits, 1 group of 7 bits
    wire [4:0] pc8_out [7:0];  // 5 bits wide for popcount8 outputs
    wire [3:0] pc7_out;        // 4 bits wide for popcount7 output

    // Instantiate popcount8 units
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin: gen_pc8
            popcount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(pc8_out[i])
            );
        end
    endgenerate

    // Instantiate popcount7 for last 7 bits
    popcount7 pc7 (
        .in(in[255-7:255-7+7-1]), // in[248:254]
        .out(pc7_out)
    );

    // Level 1: sum pairs of pc8 outputs (5-bit inputs) plus the single pc7_out zero-extended to 5 bits
    // 8 pc8 outputs -> 4 sums
    wire [5:0] level1 [3:0]; // 6 bits wide because max sum 16 -> 5 bits + 1

    generate
        for (i=0; i<4; i=i+1) begin: gen_level1
            adder #(5) add_l1 (
                .a(pc8_out[2*i]),
                .b(pc8_out[2*i+1]),
                .sum(level1[i])
            );
        end
    endgenerate

    // Add pc7_out zero extended to 5 bits to zero (used later)
    wire [5:0] pc7_ext = {1'b0, pc7_out};

    // Level 2: sum pairs of level1 outputs (6-bit inputs) -> 3 sums + 1 leftover
    wire [6:0] level2 [2:0];
    adder #(6) add_l2_0 (.a(level1[0]), .b(level1[1]), .sum(level2[0]));
    adder #(6) add_l2_1 (.a(level1[2]), .b(level1[3]), .sum(level2[1]));
    // leftover: pc7_ext zero-extended to 7 bits
    wire [6:0] level2_2 = {1'b0, pc7_ext};

    // Level 3: sum level2[0] and level2[1] (7-bit inputs) -> 8 bits
    wire [7:0] level3_0;
    adder #(7) add_l3_0 (.a(level2[0]), .b(level2[1]), .sum(level3_0));

    // Level 3: add level3_0 and level2_2 (7 and 7 bits) -> 8 bits
    wire [7:0] level3_1;
    adder #(7) add_l3_1 (.a(level3_0), .b(level2_2), .sum(level3_1));

    // Output is level3_1 truncated to 8 bits (max 255 ones fits 8 bits)
    assign out = level3_1;

endmodule