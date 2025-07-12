module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Number of input bits
    localparam N = 255;

    // Compute levels needed: ceil(log2(N)) = 8 (since 2^8=256 >=255)
    // We create an array of partial sums at each level.
    // Level 0: 255 inputs of 1 bit each
    // Level 1: sums of pairs from level 0, width=2 bits
    // Level k: sums of pairs from level k-1, width=k+1 bits

    // Declare wires for each level with their widths and counts
    // We'll store all levels in a generate-friendly 2D wire array.

    // To do this in Verilog, use unpacked arrays of vectors for each level.

    // Max levels = 8
    // Level 0 count = 255, width=1
    // Level 1 count = ceil(255/2)=128, width=2
    // Level 2 count = ceil(128/2)=64, width=3
    // Level 3 count = 32, width=4
    // Level 4 count = 16, width=5
    // Level 5 count = 8, width=6
    // Level 6 count = 4, width=7
    // Level 7 count = 2, width=8
    // Level 8 count = 1, width=9 (max sum can be 255, 8 bits sufficient; 9 bits is safe)

    // For the final output, 8 bits suffice (max 255), so we assign accordingly.

    // Using a generate block to create the levels:

    // Declare arrays for levels
    // Use two-dimensional wires: levels[level][index] with widths

    // Define per level:
    // count_level[k] = ceil(count_level[k-1]/2)
    // width_level[k] = width_level[k-1] +1

    // Predefine counts and widths for clarity:
    localparam int count_level [0:8] = '{255,128,64,32,16,8,4,2,1};
    localparam int width_level [0:8] = '{1,2,3,4,5,6,7,8,9};

    // Declare arrays to hold partial sums
    // Can't declare variable width packed arrays in Verilog, so declare wires per level manually

    // Level 0: input bits as 1-bit vectors
    wire [0:0] level0 [0:254];
    genvar i;
    generate
        for (i=0; i < 255; i=i+1) begin
            assign level0[i][0] = in[i];
        end
    endgenerate

    // Declare wires for levels 1 to 8
    // Using generate for each level:

    // For levels 1 to 8, declare arrays and assign sums:
    // sum of two width_level[k-1] vectors plus carry (max +1 bit)
    // If odd number of elements, the last one is carried forward without change

    genvar lvl, idx;
    // Create arrays to hold partial sums per level
    // We'll use generate-for loops for each level to assign sums

    // Declare wires as arrays for each level:
    // To handle variable widths, declare packed vectors with width_level[lvl]

    // For easier code, use 2D unpacked arrays with packed elements per level as local params

    // Level wires declarations:
    // level1: wire [1:0] level1 [0:127];
    // ...
    // level8: wire [8:0] level8 [0:0];

    // We'll declare all needed wires here:
    // Can't use arrays of vectors in Verilog-2001 easily, so define as arrays of vectors:

    // Use generate to declare them:

    // Helper macro for declaration:
    // We'll declare wires inside generate block to scope them

    // Final result from level8[0], width=9, but max count 255 fits in 8 bits, so assign lower 8 bits to out

    // Implementation:

    // Declare arrays for levels 1 to 8
    // width and count arrays as per above

    // We'll proceed with nested generates

    // The actual summation logic for each level:
    // level[lvl][idx] = sum of level[lvl-1][2*idx] + level[lvl-1][2*idx+1]
    // if odd number of elements at level[lvl-1], last element passes through unchanged

    // Finally assign out = level8[0][7:0];

    // Note: to avoid repetitive code, use a recursive generate pattern.

    // Since SystemVerilog features may be limited, we write code for each level explicitly.

    // Level 1:
    wire [1:0] level1 [0:127];
    generate
        for (idx=0; idx < 127; idx=idx+1) begin
            assign level1[idx] = level0[2*idx] + level0[2*idx+1];
        end
        // Handle odd element
        assign level1[127] = {1'b0, level0[254]};
    endgenerate

    // Level 2:
    wire [2:0] level2 [0:63];
    generate
        for (idx=0; idx < 63; idx=idx+1) begin
            assign level2[idx] = level1[2*idx] + level1[2*idx+1];
        end
        assign level2[63] = {1'b0, level1[127]};
    endgenerate

    // Level 3:
    wire [3:0] level3 [0:31];
    generate
        for (idx=0; idx < 31; idx=idx+1) begin
            assign level3[idx] = level2[2*idx] + level2[2*idx+1];
        end
        assign level3[31] = {1'b0, level2[63]};
    endgenerate

    // Level 4:
    wire [4:0] level4 [0:15];
    generate
        for (idx=0; idx < 15; idx=idx+1) begin
            assign level4[idx] = level3[2*idx] + level3[2*idx+1];
        end
        assign level4[15] = {1'b0, level3[31]};
    endgenerate

    // Level 5:
    wire [5:0] level5 [0:7];
    generate
        for (idx=0; idx < 7; idx=idx+1) begin
            assign level5[idx] = level4[2*idx] + level4[2*idx+1];
        end
        assign level5[7] = {1'b0, level4[15]};
    endgenerate

    // Level 6:
    wire [6:0] level6 [0:3];
    generate
        for (idx=0; idx < 3; idx=idx+1) begin
            assign level6[idx] = level5[2*idx] + level5[2*idx+1];
        end
        assign level6[3] = {1'b0, level5[7]};
    endgenerate

    // Level 7:
    wire [7:0] level7 [0:1];
    generate
        for (idx=0; idx < 1; idx=idx+1) begin
            assign level7[idx] = level6[2*idx] + level6[2*idx+1];
        end
        assign level7[1] = {1'b0, level6[3]};
    endgenerate

    // Level 8:
    wire [8:0] level8 [0:0];
    assign level8[0] = level7[0] + level7[1];

    // Assign lower 8 bits to output (max 255 fits in 8 bits)
    assign out = level8[0][7:0];

endmodule