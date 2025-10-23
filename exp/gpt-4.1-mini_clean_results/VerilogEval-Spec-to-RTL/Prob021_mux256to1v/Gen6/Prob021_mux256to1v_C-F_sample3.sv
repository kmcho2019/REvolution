module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Function to select one 4-bit slice among 16 slices from input,
    // given base offset (slice group) and 4-bit lower sel
    function [3:0] mux16_4bit;
        input [1023:0] data;
        input [7:0] base_index; // base_index is 0,16,32,...,240 for the group of 16 slices
        input [3:0]  sel4;      // select index inside the group (0..15)
        reg [3:0] slice_indices [0:15];
        integer i;
    begin
        for (i = 0; i < 16; i = i + 1) begin
            slice_indices[i] = data[(base_index + i)*4 +: 4];
        end
        mux16_4bit = slice_indices[sel4];
    end
    endfunction

    // Stage 1: 16 16-to-1 muxes, each selecting one 4-bit slice from 16 contiguous slices
    // Using sel[3:0] for selection within each 16-slice group
    wire [3:0] stage1_out [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1_gen
            assign stage1_out[i] = mux16_4bit(in, i*16, sel[3:0]);
        end
    endgenerate

    // Stage 2: 4 4-to-1 muxes selecting among 4 stage1 outputs, using sel[5:4]
    wire [3:0] stage2_out [0:3];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : stage2_gen
            assign stage2_out[j] =
                (sel[5:4] == 2'd0) ? stage1_out[j*4 + 0] :
                (sel[5:4] == 2'd1) ? stage1_out[j*4 + 1] :
                (sel[5:4] == 2'd2) ? stage1_out[j*4 + 2] :
                                     stage1_out[j*4 + 3];
        end
    endgenerate

    // Stage 3: Final 4-to-1 mux selecting among stage2 outputs, using sel[7:6]
    assign out =
        (sel[7:6] == 2'd0) ? stage2_out[0] :
        (sel[7:6] == 2'd1) ? stage2_out[1] :
        (sel[7:6] == 2'd2) ? stage2_out[2] :
                             stage2_out[3];

endmodule