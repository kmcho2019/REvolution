module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Number of segments and segment width
    localparam NUM_SEG = 16;
    localparam SEG_WIDTH = 32;

    // Pipeline index: which segment to update this clock cycle
    reg [3:0] seg_idx;

    // Wires to hold neighbors for current segment update
    wire [SEG_WIDTH-1:0] curr_seg = q[seg_idx*SEG_WIDTH +: SEG_WIDTH];
    wire [SEG_WIDTH-1:0] left_seg = (seg_idx == 0) ? {SEG_WIDTH{1'b0}} : q[(seg_idx-1)*SEG_WIDTH +: SEG_WIDTH];
    wire [SEG_WIDTH-1:0] right_seg = (seg_idx == NUM_SEG-1) ? {SEG_WIDTH{1'b0}} : q[(seg_idx+1)*SEG_WIDTH +: SEG_WIDTH];

    // Compute next_state for the current segment
    wire [SEG_WIDTH-1:0] next_seg_state;
    genvar i;
    generate
        for (i = 0; i < SEG_WIDTH; i = i + 1) begin : gen_next_seg
            wire left_bit;
            wire right_bit;

            // For bit i in current segment:
            // Left neighbor:
            // if i == 0, left neighbor is bit 31 of left_seg (or 0 if no left segment)
            // else, left neighbor is curr_seg[i-1]
            assign left_bit = (i == 0) ? left_seg[SEG_WIDTH-1] : curr_seg[i-1];

            // Right neighbor:
            // if i == SEG_WIDTH-1, right neighbor is bit 0 of right_seg (or 0 if no right segment)
            // else, right neighbor is curr_seg[i+1]
            assign right_bit = (i == SEG_WIDTH-1) ? right_seg[0] : curr_seg[i+1];

            assign next_seg_state[i] = left_bit ^ right_bit;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            seg_idx <= 0;  // reset segment index on load
        end else begin
            // Update only current segment with next state, others remain unchanged
            q <= q;  // default: hold current state

            // Update current segment bits with computed next state
            q[seg_idx*SEG_WIDTH +: SEG_WIDTH] <= next_seg_state;

            // Move to next segment for next clock cycle
            if (seg_idx == NUM_SEG - 1)
                seg_idx <= 0;
            else
                seg_idx <= seg_idx + 1;
        end
    end

endmodule