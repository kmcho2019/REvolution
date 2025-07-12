module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => needs 5 bits, 6 bits for margin
);
    // Popcount 4 bits function: sum bits explicitly
    function [2:0] popcount4;
        input [3:0] bits;
        begin
            popcount4 = bits[0] + bits[1] + bits[2] + bits[3];
        end
    endfunction

    wire [2:0] sum0 = popcount4(in[3:0]);
    wire [2:0] sum1 = popcount4(in[7:4]);
    wire [2:0] sum2 = popcount4(in[11:8]);
    wire [2:0] sum3 = popcount4(in[15:12]);
    wire       sum4 = in[16];

    // sum0 and sum1: max 4 bits (3 bits + 3 bits = 4 bits)
    wire [3:0] sum01 = sum0 + sum1;
    wire [3:0] sum23 = sum2 + sum3;

    // sum01 + sum23: max 5 bits (4 bits + 4 bits = 5 bits)
    wire [4:0] sum0123 = sum01 + sum23;

    // sum0123 + sum4: max 6 bits
    wire [5:0] total = sum0123 + sum4;

    assign out = total;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Number of partial blocks
    localparam N = 15;
    // Each partial count max 17 (6 bits)
    // Max total sum = 15 * 17 = 255 (fits in 8 bits)

    // 1) Instantiate 15 popcount17 modules for 17-bit chunks
    wire [5:0] partial_counts [N-1:0];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // 2) Balanced adder tree with minimal bitwidth per level to sum partial_counts

    // Helper function to calculate ceil(log2(x))
    function integer clog2;
        input integer value;
        integer j;
        begin
            clog2 = 0;
            for (j = value - 1; j > 0; j = j >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    // Calculate tree levels needed: ceil(log2(N))
    localparam LEVELS = clog2(N);

    // To optimize bit width per level:
    // At level 0 (partial_counts), max value per element = 17 (6 bits)
    // Each subsequent level sums two elements from previous level,
    // so max sum doubles approximately.
    //
    // So width per level = ceil(log2(max_possible_sum_at_level)) bits
    // max sum at level L = (2^L) * 17

    // Calculate bit width per level
    localparam [LEVELS:0] level_widths = {
        8'd0, // dummy for index alignment (unused)
        8'd6, // level 0 width (6 bits for 17 max)
        8'd7, // level 1 width (max sum ~ 2*17=34 -> 6 bits is 64, so 6 bits still enough, but let's use precise)
        8'd8, // level 2 (4*17=68 < 128, so 7 bits enough)
        8'd8, // level 3 (8*17=136 < 256, 8 bits)
        8'd8  // level 4 (16*17=272 > 255, but max sum is only 15*17=255)
    };

    // We'll use a function to get minimal width at given level:
    function integer level_width;
        input integer level;
        integer val;
        begin
            // max sum at this level is 17 * 2^level but no more than 15*17=255
            val = 17 * (1 << level);
            if (val > 255)
                val = 255; // cap at total max
            // width needed is clog2(val + 1) to cover max sum exactly
            level_width = clog2(val + 1);
        end
    endfunction

    // 3) Declare arrays for partial sums per level

    // Because size halves each level
    // Use packed arrays of wires indexed [level][index]
    // We store level 0 partial_counts zero-extended to their width for that level

    // To handle variable widths per level, use unpacked arrays of reg/wire vectors

    // Max width needed across all levels:
    localparam MAX_WIDTH = 8; // 8 bits suffice for max sum=255

    // For flexibility, declare as separate arrays per level
    // Size per level: ceil(N/(2^level))

    // Declare all levels signals as wires with max width; slices used for real width
    // Alternative is to declare reg arrays or use packed arrays with max width, then assign slices.
    // For clarity, use an array of wires per level.

    // Calculate sizes per level
    function integer level_size;
        input integer level;
        begin
            level_size = (N + (1 << level) - 1) >> level;
        end
    endfunction

    // Declare wires for each level sums
    // Because Verilog does not support variable width arrays easily, declare max width and zero-pad unused bits

    // Level 0 sum signals (width depends on popcount output width = 6 bits)
    wire [MAX_WIDTH-1:0] sum_level_0 [0:level_size(0)-1];
    // Level 1 ... up to LEVELS
    wire [MAX_WIDTH-1:0] sum_level   [1:LEVELS][0:level_size(LEVELS)-1]; // max index for highest level

    // Assign level 0 partial counts zero-extended to sum_level_0
    generate
        for (i = 0; i < level_size(0); i = i + 1) begin : assign_level0
            if (i < N) begin
                // zero-extend partial_counts[i] (6 bits) to MAX_WIDTH (8 bits)
                assign sum_level_0[i] = {{(MAX_WIDTH - 6){1'b0}}, partial_counts[i]};
            end else begin
                // pad unused elements with zero
                assign sum_level_0[i] = {MAX_WIDTH{1'b0}};
            end
        end
    endgenerate

    // Build balanced adder tree from level 1 to LEVELS
    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : levels
            localparam integer prev_size = level_size(lvl - 1);
            localparam integer curr_size = level_size(lvl);
            for (idx = 0; idx < curr_size; idx = idx + 1) begin : sums
                localparam integer idx0 = 2 * idx;
                localparam integer idx1 = idx0 + 1;

                // widths for this and previous levels
                localparam integer w_prev = level_width(lvl - 1);
                localparam integer w_curr = level_width(lvl);

                // inputs from previous level zero-padded to w_prev bits
                wire [w_prev-1:0] in0;
                wire [w_prev-1:0] in1;

                // Extract relevant bits from sum_level arrays, pad upper bits with 0
                if (lvl == 1) begin
                    assign in0 = (idx0 < prev_size) ? sum_level_0[idx0][w_prev-1:0] : {w_prev{1'b0}};
                    assign in1 = (idx1 < prev_size) ? sum_level_0[idx1][w_prev-1:0] : {w_prev{1'b0}};
                end else begin
                    assign in0 = (idx0 < prev_size) ? sum_level[lvl-1][idx0][w_prev-1:0] : {w_prev{1'b0}};
                    assign in1 = (idx1 < prev_size) ? sum_level[lvl-1][idx1][w_prev-1:0] : {w_prev{1'b0}};
                end

                // Sum inputs and assign zero-extended to MAX_WIDTH bits, top bits zeroed
                wire [w_curr-1:0] sum = in0 + in1;

                // Assign to sum_level at current level, zero-extend to MAX_WIDTH
                assign sum_level[lvl][idx] = {{(MAX_WIDTH - w_curr){1'b0}}, sum};
            end
        end
    endgenerate

    // Final output is at sum_level[LEVELS][0], truncated to 8 bits (MAX_WIDTH=8)
    assign out = sum_level[LEVELS][0][7:0];

endmodule