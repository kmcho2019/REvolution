module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // 2-to-1 mux for a single bit
    function mux2x1_bit;
        input bit_in0;
        input bit_in1;
        input sel;
        begin
            mux2x1_bit = sel ? bit_in1 : bit_in0;
        end
    endfunction

    // Stage 1: rotate left by 4 bits if ctrl[2] == 1
    // For each output bit i: select in[(i - 4) mod 8] if ctrl[2] else in[i]
    wire [7:0] stage1;
    assign stage1 = {
        mux2x1_bit(in[7], in[3], ctrl[2]),  // out[7] = in[3] if shift else in[7]
        mux2x1_bit(in[0], in[4], ctrl[2]),  // out[6] = in[4]
        mux2x1_bit(in[1], in[5], ctrl[2]),  // out[5] = in[5]
        mux2x1_bit(in[2], in[6], ctrl[2]),  // out[4] = in[6]
        mux2x1_bit(in[3], in[7], ctrl[2]),  // out[3] = in[7]
        mux2x1_bit(in[4], in[0], ctrl[2]),  // out[2] = in[0]
        mux2x1_bit(in[5], in[1], ctrl[2]),  // out[1] = in[1]
        mux2x1_bit(in[6], in[2], ctrl[2])   // out[0] = in[2]
    };

    // Stage 2: rotate left by 2 bits if ctrl[1] == 1
    // For each output bit i: select stage1[(i - 2) mod 8] if ctrl[1] else stage1[i]
    wire [7:0] stage2;
    assign stage2 = {
        mux2x1_bit(stage1[7], stage1[5], ctrl[1]),  // out[7] = stage1[5]
        mux2x1_bit(stage1[0], stage1[6], ctrl[1]),  // out[6] = stage1[6]
        mux2x1_bit(stage1[1], stage1[7], ctrl[1]),  // out[5] = stage1[7]
        mux2x1_bit(stage1[2], stage1[0], ctrl[1]),  // out[4] = stage1[0]
        mux2x1_bit(stage1[3], stage1[1], ctrl[1]),  // out[3] = stage1[1]
        mux2x1_bit(stage1[4], stage1[2], ctrl[1]),  // out[2] = stage1[2]
        mux2x1_bit(stage1[5], stage1[3], ctrl[1]),  // out[1] = stage1[3]
        mux2x1_bit(stage1[6], stage1[4], ctrl[1])   // out[0] = stage1[4]
    };

    // Stage 3: rotate left by 1 bit if ctrl[0] == 1
    // For each output bit i: select stage2[(i - 1) mod 8] if ctrl[0] else stage2[i]
    assign out = {
        mux2x1_bit(stage2[7], stage2[6], ctrl[0]),  // out[7] = stage2[6]
        mux2x1_bit(stage2[0], stage2[7], ctrl[0]),  // out[6] = stage2[7]
        mux2x1_bit(stage2[1], stage2[0], ctrl[0]),  // out[5] = stage2[0]
        mux2x1_bit(stage2[2], stage2[1], ctrl[0]),  // out[4] = stage2[1]
        mux2x1_bit(stage2[3], stage2[2], ctrl[0]),  // out[3] = stage2[2]
        mux2x1_bit(stage2[4], stage2[3], ctrl[0]),  // out[2] = stage2[3]
        mux2x1_bit(stage2[5], stage2[4], ctrl[0]),  // out[1] = stage2[4]
        mux2x1_bit(stage2[6], stage2[5], ctrl[0])   // out[0] = stage2[5]
    };

endmodule