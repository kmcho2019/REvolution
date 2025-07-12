module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding a zero MSB
    wire [255:0] in_padded = {1'b0, in};

    // Number of reduction stages: log2(256) = 8
    // We'll iteratively reduce the vector of counts from 256 to 1
    // Each stage halves the width and increases the bit-width of sums by 1

    // Intermediate vectors to hold counts at each stage
    // Use arrays indexed by stage, each element stores a sum
    // stage 0 holds the bits (width=1)
    // stage 1 holds sums of 2 bits (width=2)
    // stage n holds sums of 2^n bits (width=n+1)

    // Define widths and lengths for each stage
    localparam integer STAGES = 8;

    // Declare registers/wires for intermediate counts
    // Because we want combinational logic only, use wire arrays and generate blocks

    // Declare intermediate signals as 2D arrays: stage x element
    // Using packed arrays inside generate block is SystemVerilog feature; in pure Verilog we use vectors and calculate indices

    // For simpler code, use arrays of wires for each stage
    // We'll use a generate loop to build each stage from the previous

    // Stage widths: number of elements at each stage
    wire [STAGES:0][255:0] stage_counts; // max 256 elements at stage 0 down to 1 element at stage 8
    // stage_counts[0] holds bits (1 bit each)
    // stage_counts[s][i] holds sums of 2^s bits (s+1 bits wide)
    // Because Verilog doesn't support multi-dimensional packed arrays portably, do manual slicing

    // Define a function to calculate bit-width for stage s
    function integer bit_width;
        input integer stage;
        begin
            bit_width = stage + 1;
        end
    endfunction

    // Declare wires for stage_counts:
    // At stage 0: 256 bits (each 1 bit wide)
    // At stage 1: 128 elements, each 2 bits wide
    // ...
    // At stage 8: 1 element, 9 bits wide

    // We'll implement stage_counts as separate wires per stage with proper widths

    // Stage 0 (input bits)
    wire [255:0] stage0;
    assign stage0 = in_padded;

    // Declare arrays of wires for each stage 1..8
    // Use vectors with concatenation to emulate arrays

    // Stage 1: 128 elements, 2 bits each => total 256 bits
    wire [127:0][1:0] stage1;

    // Stage 2: 64 elements, 3 bits each
    wire [63:0][2:0] stage2;

    // Stage 3: 32 elements, 4 bits each
    wire [31:0][3:0] stage3;

    // Stage 4: 16 elements, 5 bits each
    wire [15:0][4:0] stage4;

    // Stage 5: 8 elements, 6 bits each
    wire [7:0][5:0] stage5;

    // Stage 6: 4 elements, 7 bits each
    wire [3:0][6:0] stage6;

    // Stage 7: 2 elements, 8 bits each
    wire [1:0][7:0] stage7;

    // Stage 8: 1 element, 9 bits
    wire [8:0] stage8;

    genvar i;
    // Stage 1: sum pairs of bits from stage0
    generate
        for (i = 0; i < 128; i = i + 1) begin : stage1_gen
            assign stage1[i] = stage0[2*i] + stage0[2*i+1];
        end
    endgenerate

    // Stage 2
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage2_gen
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
    endgenerate

    // Stage 3
    generate
        for (i = 0; i < 32; i = i + 1) begin : stage3_gen
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
    endgenerate

    // Stage 4
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage4_gen
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
    endgenerate

    // Stage 5
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage5_gen
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
    endgenerate

    // Stage 6
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage6_gen
            assign stage6[i] = stage5[2*i] + stage5[2*i+1];
        end
    endgenerate

    // Stage 7
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage7_gen
            assign stage7[i] = stage6[2*i] + stage6[2*i+1];
        end
    endgenerate

    // Stage 8
    assign stage8 = stage7[0] + stage7[1];

    // Output the lower 8 bits (max population count is 255)
    assign out = stage8[7:0];

endmodule