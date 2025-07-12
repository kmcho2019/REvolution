module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones fits in 3 bits
);
    // sum the bits straightforwardly
    assign out = in[0] + in[1] + in[2] + in[3] + in[4];
endmodule

// Generic adder module: adds two inputs of arbitrary width, output width = max input width + 1
module adder #(parameter W = 3) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W:0]   sum
);
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Step 1: Split into 51 groups of 5 bits each (51*5=255)
    wire [2:0] pop5_out [50:0]; // 51 outputs, 3 bits each

    genvar i;
    generate
        for (i=0; i<51; i=i+1) begin : gen_pop5
            popcount5 pc5 (.in(in[5*i +: 5]), .out(pop5_out[i]));
        end
    endgenerate

    // Step 2: Sum these 51 3-bit values in a balanced binary tree
    // Level 0: 51 inputs of width 3 bits

    // We will create successive levels until one final sum remains.
    // Each adder merges two inputs of W bits into W+1 bits output.

    // Level 1: add pairs of pop5_out (3-bit each)
    // 51 inputs => 25 pairs + 1 leftover
    localparam N0 = 51;
    localparam W0 = 3;

    // Function to calculate number of pairs and leftovers at each stage
    function integer pairs_count(input integer n);
        pairs_count = n/2;
    endfunction
    function integer leftovers_count(input integer n);
        leftovers_count = n % 2;
    endfunction

    // Use arrays of wires to hold each level outputs and widths
    // Because Verilog does not support multi-dimensional packed arrays with variable widths easily,
    // we manually declare levels up to level 5 which suffices for 51 inputs.

    // Level widths increase by 1 every time we do an addition.

    // Level 1 outputs: 25 adders with 3-bit inputs -> output 4-bit, plus 1 leftover 3-bit value extended to 4-bit
    localparam N1 = pairs_count(N0) + leftovers_count(N0);
    localparam W1 = W0 + 1;
    wire [W1-1:0] level1 [N1-1:0];

    // instantiate adders for pairs
    generate
        for (i=0; i<pairs_count(N0); i=i+1) begin : gen_level1_adder
            adder #(W0) add (
                .a(pop5_out[2*i]),
                .b(pop5_out[2*i+1]),
                .sum(level1[i])
            );
        end
        // handle leftover
        if (leftovers_count(N0)) begin : gen_level1_leftover
            // zero extend leftover from 3 to 4 bits
            assign level1[N1-1] = {1'b0, pop5_out[N0-1]};
        end
    endgenerate

    // Level 2
    // Inputs: N1 numbers, each W1 bits
    localparam N2 = pairs_count(N1) + leftovers_count(N1);
    localparam W2 = W1 + 1;
    wire [W2-1:0] level2 [N2-1:0];

    generate
        for (i=0; i<pairs_count(N1); i=i+1) begin : gen_level2_adder
            adder #(W1) add (
                .a(level1[2*i]),
                .b(level1[2*i+1]),
                .sum(level2[i])
            );
        end
        if (leftovers_count(N1)) begin : gen_level2_leftover
            assign level2[N2-1] = {1'b0, level1[N1-1]};
        end
    endgenerate

    // Level 3
    localparam N3 = pairs_count(N2) + leftovers_count(N2);
    localparam W3 = W2 + 1;
    wire [W3-1:0] level3 [N3-1:0];

    generate
        for (i=0; i<pairs_count(N2); i=i+1) begin : gen_level3_adder
            adder #(W2) add (
                .a(level2[2*i]),
                .b(level2[2*i+1]),
                .sum(level3[i])
            );
        end
        if (leftovers_count(N2)) begin : gen_level3_leftover
            assign level3[N3-1] = {1'b0, level2[N2-1]};
        end
    endgenerate

    // Level 4
    localparam N4 = pairs_count(N3) + leftovers_count(N3);
    localparam W4 = W3 + 1;
    wire [W4-1:0] level4 [N4-1:0];

    generate
        for (i=0; i<pairs_count(N3); i=i+1) begin : gen_level4_adder
            adder #(W3) add (
                .a(level3[2*i]),
                .b(level3[2*i+1]),
                .sum(level4[i])
            );
        end
        if (leftovers_count(N3)) begin : gen_level4_leftover
            assign level4[N4-1] = {1'b0, level3[N3-1]};
        end
    endgenerate

    // Level 5
    localparam N5 = pairs_count(N4) + leftovers_count(N4);
    localparam W5 = W4 + 1;
    wire [W5-1:0] level5 [N5-1:0];

    generate
        for (i=0; i<pairs_count(N4); i=i+1) begin : gen_level5_adder
            adder #(W4) add (
                .a(level4[2*i]),
                .b(level4[2*i+1]),
                .sum(level5[i])
            );
        end
        if (leftovers_count(N4)) begin : gen_level5_leftover
            assign level5[N5-1] = {1'b0, level4[N4-1]};
        end
    endgenerate

    // Level 6 (if needed)
    // Since N5 <= (N4+1)/2, and N4 <= (N3+1)/2 etc., for 51 inputs, after 6 levels we'll have a single sum

    wire [W6-1:0] level6; // final sum
    localparam N6 = pairs_count(N5) + leftovers_count(N5);
    localparam W6 = W5 + 1;

    generate
        if (N5 == 1) begin
            // only one value, no addition needed
            assign level6 = level5[0];
        end else if (N5 == 2) begin
            // add two values
            adder #(W5) add (
                .a(level5[0]),
                .b(level5[1]),
                .sum(level6)
            );
        end else begin
            // More than 2 values should not happen for 51 inputs after 5 stages
            // But for completeness:
            wire [W5:0] sums [ (N5+1)/2 -1 :0 ];
            genvar j;
            for (j=0; j<(N5/2); j=j+1) begin : gen_level6_adders
                adder #(W5) add_inner (
                    .a(level5[2*j]),
                    .b(level5[2*j+1]),
                    .sum(sums[j])
                );
            end
            if (N5 % 2) begin
                // leftover zero extended
                wire [W5:0] leftover = {1'b0, level5[N5-1]};
                // Add leftover to sums[0] for final sum
                adder #(W5+1) add_final (
                    .a(sums[0]),
                    .b(leftover),
                    .sum(level6)
                );
            end else begin
                // Just pick sums[0] as final
                assign level6 = sums[0];
            end
        end
    endgenerate

    // The final sum level6 is max 11 bits wide (3+6 additions), which covers counting up to 255 ones (8 bits)

    // Output the lowest 8 bits, which safely holds values up to 255
    assign out = level6[7:0];

endmodule