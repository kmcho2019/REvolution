module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Split q into 8 segments of 8 bits
    wire [7:0] seg[7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin
            assign seg[i] = q[8*i +: 8];
        end
    endgenerate

    wire msb = q[63];
    wire [7:0] msb_fill = {8{msb}};

    // Shift left by 1 bit within 8-bit segments with carry from lower segment
    wire [7:0] left1_seg[7:0];
    // Shift left by 8 bits: move segments up by one, fill LSB segment with 0
    wire [7:0] left8_seg[7:0];
    // Arithmetic shift right by 1 bit with carry from higher segment
    wire [7:0] right1_seg[7:0];
    // Arithmetic shift right by 8 bits: move segments down by one, fill MSB segment with msb_fill
    wire [7:0] right8_seg[7:0];

    // LEFT SHIFT BY 1:
    // For each segment, shift left 1 bit and input LSB from previous lower segment MSB bit
    // For segment 0, input LSB is 0
    // bit ordering within 8-bit segment: [7:0], MSB is bit 7, LSB is bit 0

    // Construct left shift by 1:
    // left1_seg[i] = {seg[i][6:0], bit_from_lower_segment}
    // bit_from_lower_segment = seg[i-1][7], or 0 if i==0

    generate
        for (i=0; i<8; i=i+1) begin : GEN_LEFT1
            wire bit_in;
            if (i==0)
                assign bit_in = 1'b0;
            else
                assign bit_in = seg[i-1][7];
            assign left1_seg[i] = {seg[i][6:0], bit_in};
        end
    endgenerate

    // LEFT SHIFT BY 8:
    // segments rotate up: seg[i] <= seg[i-1], seg[0] <= 0
    assign left8_seg[0] = 8'b0;
    generate
        for (i=1; i<8; i=i+1) begin : GEN_LEFT8
            assign left8_seg[i] = seg[i-1];
        end
    endgenerate

    // RIGHT SHIFT BY 1 (arithmetic):
    // For each segment, shift right by 1 bit and input MSB from next higher segment LSB
    // For segment 7 (top), input MSB is msb replicated (sign extension)
    // bit ordering: bit 7 MSB, bit 0 LSB
    // right1_seg[i] = {bit_from_higher_segment, seg[i][7:1]}

    generate
        for (i=0; i<8; i=i+1) begin : GEN_RIGHT1
            wire bit_in;
            if (i == 7)
                assign bit_in = msb;
            else
                assign bit_in = seg[i+1][0];
            assign right1_seg[i] = {bit_in, seg[i][7:1]};
        end
    endgenerate

    // RIGHT SHIFT BY 8 (arithmetic):
    // segments rotate down: seg[i] <= seg[i+1]
    // segment 7 <= msb_fill (sign extension)
    generate
        for (i=0; i<7; i=i+1) begin : GEN_RIGHT8
            assign right8_seg[i] = seg[i+1];
        end
    endgenerate
    assign right8_seg[7] = msb_fill;

    // Now select the shifted value based on amount:
    // amount:
    // 00: left shift 1
    // 01: left shift 8
    // 10: right shift 1 (arithmetic)
    // 11: right shift 8 (arithmetic)

    wire [7:0] shifted_seg[7:0];

    generate
        for (i=0; i<8; i=i+1) begin : GEN_SEL
            wire [7:0] shift_left = (amount[0] == 1'b0) ? left1_seg[i] : left8_seg[i];
            wire [7:0] shift_right = (amount[0] == 1'b0) ? right1_seg[i] : right8_seg[i];
            assign shifted_seg[i] = (amount[1] == 1'b0) ? shift_left : shift_right;
        end
    endgenerate

    // Combine shifted segments into 64-bit vector
    wire [63:0] shifted_value;
    generate
        for (i=0; i<8; i=i+1) begin : GEN_COMBINE
            assign shifted_value[8*i +: 8] = shifted_seg[i];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted_value;
        end
    end

endmodule