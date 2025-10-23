module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel, // 8-bit select
    output wire [3:0]    out
);
    // Decode sel to one-hot 256-bit signal
    wire [255:0] sel_one_hot = (256'b1 << sel);

    // Expand each one-hot bit to 4 bits mask to cover each 4-bit slice in 'in'
    wire [1023:0] mask;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_mask_expand
            // replicate sel_one_hot[i] 4 times at positions i*4+3 : i*4
            assign mask[i*4 +: 4] = {4{sel_one_hot[i]}};
        end
    endgenerate

    // Mask the input with the expanded mask to isolate the selected 4-bit input
    wire [1023:0] masked_in = in & mask;

    // Reduce the masked input bits to produce the 4-bit output by OR'ing each 4-bit group
    // Since only one group is selected, OR reduction over all groups selects that group
    wire [3:0] out_bits;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_bits
            integer j;
            reg bit_val;
            always @* begin
                bit_val = 1'b0;
                for (j = 0; j < 256; j = j + 1) begin
                    bit_val = bit_val | masked_in[j*4 + i];
                end
            end
            assign out[i] = bit_val;
        end
    endgenerate
endmodule