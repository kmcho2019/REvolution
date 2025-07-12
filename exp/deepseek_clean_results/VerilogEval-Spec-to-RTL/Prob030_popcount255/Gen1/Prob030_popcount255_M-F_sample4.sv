module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First stage: count 1s in groups of 3 bits (85 groups)
// Each count needs 2 bits (max value 3)
wire [1:0] stage1 [0:84];
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : stage1_counters
        assign stage1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
    end
endgenerate

// Function to recursively sum counts with proper bit widths
function [7:0] sum_counts;
    input [1:0] counts [0:84];
    integer start, end_idx;
    begin
        if (84 == 0) begin
            sum_counts = counts[0];
        end
        else begin
            // Split into two halves and recurse
            automatic [7:0] left_sum = sum_counts(counts[0:42]);
            automatic [7:0] right_sum = sum_counts(counts[43:84]);
            sum_counts = left_sum + right_sum;
        end
    end
endfunction

// Alternative implementation since recursive functions can't handle arrays in Verilog
// Instead, we'll implement the summation tree explicitly with proper bit widths

// Second stage: sum pairs of stage1 results (3 bits needed per sum)
wire [2:0] stage2 [0:42];
generate
    for (i = 0; i < 42; i = i + 1) begin : stage2_adders
        assign stage2[i] = stage1[i*2] + stage1[i*2+1];
    end
    assign stage2[42] = stage1[84];
endgenerate

// Third stage: sum pairs of stage2 results (4 bits needed)
wire [3:0] stage3 [0:21];
generate
    for (i = 0; i < 21; i = i + 1) begin : stage3_adders
        assign stage3[i] = stage2[i*2] + stage2[i*2+1];
    end
    assign stage3[21] = stage2[42];
endgenerate

// Fourth stage: sum pairs of stage3 results (5 bits needed)
wire [4:0] stage4 [0:10];
generate
    for (i = 0; i < 10; i = i + 1) begin : stage4_adders
        assign stage4[i] = stage3[i*2] + stage3[i*2+1];
    end
    assign stage4[10] = stage3[21];
endgenerate

// Fifth stage: sum pairs of stage4 results (6 bits needed)
wire [5:0] stage5 [0:5];
generate
    for (i = 0; i < 5; i = i + 1) begin : stage5_adders
        assign stage5[i] = stage4[i*2] + stage4[i*2+1];
    end
    assign stage5[5] = stage4[10];
endgenerate

// Sixth stage: sum pairs of stage5 results (7 bits needed)
wire [6:0] stage6 [0:2];
generate
    for (i = 0; i < 2; i = i + 1) begin : stage6_adders
        assign stage6[i] = stage5[i*2] + stage5[i*2+1];
    end
    assign stage6[2] = stage5[4] + stage5[5];
endgenerate

// Final stage: sum the remaining 3 elements (8 bits needed)
assign out = stage6[0] + stage6[1] + stage6[2];

endmodule