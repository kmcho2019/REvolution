module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // We will implement a balanced binary adder tree iteratively in generate

    // Stage elements: start with 255 elements of width=1 (the bits)
    // Each stage halves the number of elements roughly and increases their width by 1
    // Continue until only one element remains

    // Calculate max stages needed: ceil(log2(255)) = 8
    localparam STAGES = 8;

    // Define a packed array to hold stage values: max size needed at stage 0 is 255 elements
    // Each element is 1 bit wide at stage 0, grows +1 bit each stage
    // Use a generate for stages

    // We will use an array of regs/wires per stage dynamically sized, declared as unpacked arrays
    // To hold all signals, use a 2D array: max 255 elements at stage 0

    // For Verilog-2001 compatibility and synthesis friendliness, we'll define wires as arrays.

    // At each stage s:
    //   - num_elements = ceil(prev_num_elements / 2)
    //   - width = s+1 (starting width 1 at stage 0)

    // Stage 0: input bits
    wire [0:254] stage_data_0; 
    assign stage_data_0 = in;

    // Use a generate loop for stages
    genvar s;

    // We will declare arrays for each stage outside generate and assign in generate
    // Because Verilog does not allow arrays of variable width easily, use separate vectors per stage.

    // Calculate element counts per stage
    function integer elem_count(input integer prev);
        return (prev + 1) / 2;
    endfunction

    // Declare signals for each stage
    // Use vectors with concatenation for stages

    // Stage widths and counts arrays (localparams) for indexing signals
    // Create a loop outside generate for convenience

    // Declare arrays to hold stage widths and counts
    integer widths[0:STAGES];
    integer counts[0:STAGES];

    initial begin
        counts[0] = 255;
        widths[0] = 1;
        integer i;
        for (i = 1; i <= STAGES; i = i +1) begin
            counts[i] = elem_count(counts[i-1]);
            widths[i] = widths[i-1] + 1;
        end
    end

    // Because initial blocks and localparams cannot be used in this way in Verilog, 
    // we will just manually define widths and counts constants:

    localparam integer counts_0 = 255;
    localparam integer widths_0 = 1;

    localparam integer counts_1 = (counts_0 +1)/2; // 128
    localparam integer widths_1 = widths_0 +1;     // 2

    localparam integer counts_2 = (counts_1 +1)/2; // 64
    localparam integer widths_2 = widths_1 +1;     // 3

    localparam integer counts_3 = (counts_2 +1)/2; // 32
    localparam integer widths_3 = widths_2 +1;     // 4

    localparam integer counts_4 = (counts_3 +1)/2; // 16
    localparam integer widths_4 = widths_3 +1;     // 5

    localparam integer counts_5 = (counts_4 +1)/2; // 8
    localparam integer widths_5 = widths_4 +1;     // 6

    localparam integer counts_6 = (counts_5 +1)/2; // 4
    localparam integer widths_6 = widths_5 +1;     // 7

    localparam integer counts_7 = (counts_6 +1)/2; // 2
    localparam integer widths_7 = widths_6 +1;     // 8

    localparam integer counts_8 = (counts_7 +1)/2; // 1
    localparam integer widths_8 = widths_7 +1;     // 9

    // Declare stage signals:
    // stage_data_0: 255 elements width=1, packed as vector: [254:0]
    wire [widths_0-1:0] stage_0 [0:counts_0-1];
    genvar i0;
    generate
        for(i0=0; i0 < counts_0; i0=i0+1) begin : assign_stage0
            assign stage_0[i0] = in[i0];
        end
    endgenerate

    // For next stages, we declare wires with correct widths and counts
    // stage_1 : counts_1 elements, width 2
    wire [widths_1-1:0] stage_1 [0:counts_1-1];
    wire [widths_2-1:0] stage_2 [0:counts_2-1];
    wire [widths_3-1:0] stage_3 [0:counts_3-1];
    wire [widths_4-1:0] stage_4 [0:counts_4-1];
    wire [widths_5-1:0] stage_5 [0:counts_5-1];
    wire [widths_6-1:0] stage_6 [0:counts_6-1];
    wire [widths_7-1:0] stage_7 [0:counts_7-1];
    wire [widths_8-1:0] stage_8 [0:counts_8-1];

    // Define a generate block macro for summing pairs for a given stage
    // If last element has no pair, carry forward as is.

    // Stage 0->1
    generate
        for(i0=0; i0 < counts_1; i0=i0+1) begin : stage0to1
            if ((2*i0 +1) < counts_0) begin
                assign stage_1[i0] = stage_0[2*i0] + stage_0[2*i0 +1];
            end else begin
                assign stage_1[i0] = stage_0[2*i0];
            end
        end
    endgenerate

    // Stage 1->2
    genvar i1;
    generate
        for(i1=0; i1 < counts_2; i1=i1+1) begin : stage1to2
            if ((2*i1 +1) < counts_1) begin
                assign stage_2[i1] = stage_1[2*i1] + stage_1[2*i1 +1];
            end else begin
                assign stage_2[i1] = stage_1[2*i1];
            end
        end
    endgenerate

    // Stage 2->3
    genvar i2;
    generate
        for(i2=0; i2 < counts_3; i2=i2+1) begin : stage2to3
            if ((2*i2 +1) < counts_2) begin
                assign stage_3[i2] = stage_2[2*i2] + stage_2[2*i2 +1];
            end else begin
                assign stage_3[i2] = stage_2[2*i2];
            end
        end
    endgenerate

    // Stage 3->4
    genvar i3;
    generate
        for(i3=0; i3 < counts_4; i3=i3+1) begin : stage3to4
            if ((2*i3 +1) < counts_3) begin
                assign stage_4[i3] = stage_3[2*i3] + stage_3[2*i3 +1];
            end else begin
                assign stage_4[i3] = stage_3[2*i3];
            end
        end
    endgenerate

    // Stage 4->5
    genvar i4;
    generate
        for(i4=0; i4 < counts_5; i4=i4+1) begin : stage4to5
            if ((2*i4 +1) < counts_4) begin
                assign stage_5[i4] = stage_4[2*i4] + stage_4[2*i4 +1];
            end else begin
                assign stage_5[i4] = stage_4[2*i4];
            end
        end
    endgenerate

    // Stage 5->6
    genvar i5;
    generate
        for(i5=0; i5 < counts_6; i5=i5+1) begin : stage5to6
            if ((2*i5 +1) < counts_5) begin
                assign stage_6[i5] = stage_5[2*i5] + stage_5[2*i5 +1];
            end else begin
                assign stage_6[i5] = stage_5[2*i5];
            end
        end
    endgenerate

    // Stage 6->7
    genvar i6;
    generate
        for(i6=0; i6 < counts_7; i6=i6+1) begin : stage6to7
            if ((2*i6 +1) < counts_6) begin
                assign stage_7[i6] = stage_6[2*i6] + stage_6[2*i6 +1];
            end else begin
                assign stage_7[i6] = stage_6[2*i6];
            end
        end
    endgenerate

    // Stage 7->8
    genvar i7;
    generate
        for(i7=0; i7 < counts_8; i7=i7+1) begin : stage7to8
            if ((2*i7 +1) < counts_7) begin
                assign stage_8[i7] = stage_7[2*i7] + stage_7[2*i7 +1];
            end else begin
                assign stage_8[i7] = stage_7[2*i7];
            end
        end
    endgenerate

    // Final popcount is stage_8[0], width=9 bits, max sum is 255 so fits in 8 bits
    assign out = stage_8[0][7:0];

endmodule