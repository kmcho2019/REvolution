module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Helper function to implement a 2-to-1 mux for a single bit
    function mux2x1_bit;
        input bit_in0;
        input bit_in1;
        input sel;
        begin
            mux2x1_bit = sel ? bit_in1 : bit_in0;
        end
    endfunction

    // Stage 1: rotate left by 4 bits if ctrl[2] == 1
    wire [7:0] stage1;
    assign stage1 = {
        mux2x1_bit(in[3], in[7], ctrl[2]),
        mux2x1_bit(in[4], in[0], ctrl[2]),
        mux2x1_bit(in[5], in[1], ctrl[2]),
        mux2x1_bit(in[6], in[2], ctrl[2]),
        mux2x1_bit(in[7], in[3], ctrl[2]),
        mux2x1_bit(in[0], in[4], ctrl[2]),
        mux2x1_bit(in[1], in[5], ctrl[2]),
        mux2x1_bit(in[2], in[6], ctrl[2])
    };

    // Stage 2: rotate left by 2 bits if ctrl[1] == 1
    wire [7:0] stage2;
    assign stage2 = {
        mux2x1_bit(stage1[5], stage1[7], ctrl[1]),
        mux2x1_bit(stage1[6], stage1[0], ctrl[1]),
        mux2x1_bit(stage1[7], stage1[1], ctrl[1]),
        mux2x1_bit(stage1[0], stage1[2], ctrl[1]),
        mux2x1_bit(stage1[1], stage1[3], ctrl[1]),
        mux2x1_bit(stage1[2], stage1[4], ctrl[1]),
        mux2x1_bit(stage1[3], stage1[5], ctrl[1]),
        mux2x1_bit(stage1[4], stage1[6], ctrl[1])
    };

    // Stage 3: rotate left by 1 bit if ctrl[0] == 1
    assign out = {
        mux2x1_bit(stage2[6], stage2[7], ctrl[0]),
        mux2x1_bit(stage2[7], stage2[0], ctrl[0]),
        mux2x1_bit(stage2[0], stage2[1], ctrl[0]),
        mux2x1_bit(stage2[1], stage2[2], ctrl[0]),
        mux2x1_bit(stage2[2], stage2[3], ctrl[0]),
        mux2x1_bit(stage2[3], stage2[4], ctrl[0]),
        mux2x1_bit(stage2[4], stage2[5], ctrl[0]),
        mux2x1_bit(stage2[5], stage2[6], ctrl[0])
    };

endmodule