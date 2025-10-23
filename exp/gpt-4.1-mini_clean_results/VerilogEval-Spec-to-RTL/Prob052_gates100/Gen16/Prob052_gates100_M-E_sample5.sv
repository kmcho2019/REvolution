module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

localparam WIDTH = 100;

// Calculate needed number of levels for balanced binary tree reduction
function integer clog2(input integer value);
    integer i;
    begin
        clog2 = 0;
        for (i = value-1; i > 0; i = i >> 1)
            clog2 = clog2 + 1;
    end
endfunction

localparam LEVELS = clog2(WIDTH);

// Pad input width to next power of two for balanced tree
localparam PADDED_WIDTH = 1 << LEVELS;

// Pad input with zeros (for AND) or ones (for OR, XOR neutral) as needed
wire [PADDED_WIDTH-1:0] padded_and_in;
wire [PADDED_WIDTH-1:0] padded_or_in;
wire [PADDED_WIDTH-1:0] padded_xor_in;

genvar i;
generate
    for (i = 0; i < PADDED_WIDTH; i = i + 1) begin
        assign padded_and_in[i] = (i < WIDTH) ? in[i] : 1'b1; // AND padding with 1 (neutral)
        assign padded_or_in[i]  = (i < WIDTH) ? in[i] : 1'b0; // OR padding with 0 (neutral)
        assign padded_xor_in[i] = (i < WIDTH) ? in[i] : 1'b0; // XOR padding with 0 (neutral)
    end
endgenerate

// Arrays of intermediate signals for each reduction level
wire [PADDED_WIDTH-1:0] and_level [0:LEVELS];
wire [PADDED_WIDTH-1:0] or_level  [0:LEVELS];
wire [PADDED_WIDTH-1:0] xor_level [0:LEVELS];

// Initialize level 0 inputs
assign and_level[0] = padded_and_in;
assign or_level[0]  = padded_or_in;
assign xor_level[0] = padded_xor_in;

genvar lvl, idx;
generate
    for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : level_reduce
        localparam PREV_WIDTH = (PADDED_WIDTH >> (lvl - 1));
        localparam CUR_WIDTH  = (PADDED_WIDTH >> lvl);
        for (idx = 0; idx < CUR_WIDTH; idx = idx + 1) begin : pair_reduce
            assign and_level[lvl][idx] = and_level[lvl-1][2*idx] & and_level[lvl-1][2*idx+1];
            assign or_level[lvl][idx]  = or_level[lvl-1][2*idx]  | or_level[lvl-1][2*idx+1];
            assign xor_level[lvl][idx] = xor_level[lvl-1][2*idx] ^ xor_level[lvl-1][2*idx+1];
        end
        // For odd case, if PREV_WIDTH is odd, pass last element up unchanged
        if (PREV_WIDTH % 2 == 1) begin : odd_case
            assign and_level[lvl][CUR_WIDTH] = and_level[lvl-1][PREV_WIDTH-1];
            assign or_level[lvl][CUR_WIDTH]  = or_level[lvl-1][PREV_WIDTH-1];
            assign xor_level[lvl][CUR_WIDTH] = xor_level[lvl-1][PREV_WIDTH-1];
        end
    end
endgenerate

// Determine final index of result after last level (handle odd case)
localparam FINAL_IDX = ((PADDED_WIDTH >> LEVELS) > 0) ? 0 : 0;

assign out_and = and_level[LEVELS][FINAL_IDX];
assign out_or  = or_level[LEVELS][FINAL_IDX];
assign out_xor = xor_level[LEVELS][FINAL_IDX];

endmodule