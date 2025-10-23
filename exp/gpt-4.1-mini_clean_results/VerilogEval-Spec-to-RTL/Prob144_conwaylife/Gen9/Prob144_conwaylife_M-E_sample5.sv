module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam MASK = 4'hF; // For mod16 wrap of row indices

    // State represented as 16 rows of 16 bits each
    reg [15:0] state_r [0:SIZE-1];

    // Next state rows after stage2 computation
    reg [15:0] next_state_r [0:SIZE-1];

    // Stage 1 registers: partial sums for each cell: three 16-bit vectors
    // partial sums: sum_top (3 neighbors above),
    //               sum_mid (2 neighbors same row, excluding self),
    //               sum_bot (3 neighbors below)
    reg [1:0] sum_top [0:SIZE-1]; // 16-bit vectors of 2-bit partial sums per cell (up to 3)
    reg [1:0] sum_mid [0:SIZE-1];
    reg [1:0] sum_bot [0:SIZE-1];

    // Pipeline registers for stage1 partial sums
    reg [1:0] sum_top_reg [0:SIZE-1];
    reg [1:0] sum_mid_reg [0:SIZE-1];
    reg [1:0] sum_bot_reg [0:SIZE-1];

    // Helper function: rotate left 16-bit vector by 1 bit (wrap-around)
    function [15:0] rotl1;
        input [15:0] in;
        begin
            rotl1 = {in[14:0], in[15]};
        end
    endfunction

    // Helper function: rotate right 16-bit vector by 1 bit (wrap-around)
    function [15:0] rotr1;
        input [15:0] in;
        begin
            rotr1 = {in[0], in[15:1]};
        end
    endfunction

    integer i;

    // Load input vector into state_r on load
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                state_r[i] <= data[i*SIZE +: SIZE];
            end
        end else begin
            // Update state with computed next_state_r
            for (i = 0; i < SIZE; i = i + 1) begin
                state_r[i] <= next_state_r[i];
            end
        end
    end

    // Stage 1: Compute partial sums for each row
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            // Row indices with wrap-around
            integer r_top = (i == 0) ? SIZE-1 : i-1;
            integer r_bot = (i == SIZE-1) ? 0 : i+1;

            // Extract neighbor rows
            // Horizontal neighbors via rotate operations
            // top neighbors: 3 cells in row above: left, center, right of cell
            // top_row bits: state_r[r_top]
            // top neighbors per cell: bits rotated right, center, rotated left
            // sum_top partial sum per bit: sum bits of these three neighbors

            // sum_top[i] is vector of partial sums (2 bits per cell) => up to 3
            // For vector sum of bits: use bitwise addition of 3 vectors

            // Extract top neighbors bits
            wire [15:0] top_left = rotr1(state_r[r_top]);
            wire [15:0] top_mid  = state_r[r_top];
            wire [15:0] top_right= rotl1(state_r[r_top]);

            // sum top partial: add bitwise top_left + top_mid + top_right per bit
            // Since these are bits, sum per bit is 0..3, fits in 2 bits
            reg [1:0] tmp_sum_top [0:15];
            integer c;
            for (c=0; c<16; c=c+1) begin
                tmp_sum_top[c] = top_left[c] + top_mid[c] + top_right[c];
            end

            // Pack into 16 2-bit partial sums vector
            sum_top[i] = 0;
            for (c=0; c<16; c=c+1) begin
                sum_top[i][c] = tmp_sum_top[c][0];     // LSB bit 0 of 2-bit partial sum
            end
            // Actually we can't pack 2 bits per cell in a single 16-bit vector directly.
            // We'll use 16 elements array of 2-bit numbers instead.

            // Similarly for mid and bot partial sums, but mid has only two neighbors horizontally (excluding self)
            // mid neighbors: left and right of same row (2 neighbors)
            // sum_mid partial = state_r[i] rotated left + state_r[i] rotated right

            // Compute mid partial sums per bit: 0..2
            reg [1:0] tmp_sum_mid [0:15];
            wire [15:0] mid_left = rotr1(state_r[i]);
            wire [15:0] mid_right= rotl1(state_r[i]);
            for (c=0; c<16; c=c+1) begin
                tmp_sum_mid[c] = mid_left[c] + mid_right[c];
            end

            // bot neighbors: like top neighbors, three neighbors below (left, mid, right)
            wire [15:0] bot_left  = rotr1(state_r[r_bot]);
            wire [15:0] bot_mid   = state_r[r_bot];
            wire [15:0] bot_right = rotl1(state_r[r_bot]);
            reg [1:0] tmp_sum_bot [0:15];
            for (c=0; c<16; c=c+1) begin
                tmp_sum_bot[c] = bot_left[c] + bot_mid[c] + bot_right[c];
            end

            // We can't assign these arrays directly to registers of different shape, so stage 1 partial sums must be arrays
            // We will use pipeline registers for these arrays in the always_ff below
            // For now, store partial sums into temporary reg arrays via generate block below
        end
    end

    // Because Verilog does not allow assigning variable sized arrays in combinational always block with loops nicely,
    // implement Stage1 partial sums via generate blocks for arrays.

    // Intermediate signals for partial sums (arrays of 2-bit numbers)
    wire [1:0] top_partial_sums [0:SIZE-1][0:SIZE-1]; // [row][col]
    wire [1:0] mid_partial_sums [0:SIZE-1][0:SIZE-1];
    wire [1:0] bot_partial_sums [0:SIZE-1][0:SIZE-1];

    genvar r,c;
    generate
        for (r=0; r<SIZE; r=r+1) begin : GEN_STAGE1
            localparam integer r_top = (r == 0) ? SIZE-1 : r-1;
            localparam integer r_bot = (r == SIZE-1) ? 0 : r+1;

            for (c=0; c<SIZE; c=c+1) begin : GEN_STAGE1_COLS
                wire top_left_bit = state_r[r_top][(c==0)? SIZE-1 : c-1];
                wire top_mid_bit  = state_r[r_top][c];
                wire top_right_bit= state_r[r_top][(c==SIZE-1)? 0 : c+1];
                assign top_partial_sums[r][c] = top_left_bit + top_mid_bit + top_right_bit;

                wire mid_left_bit = state_r[r][(c==0)? SIZE-1 : c-1];
                wire mid_right_bit= state_r[r][(c==SIZE-1)? 0 : c+1];
                assign mid_partial_sums[r][c] = mid_left_bit + mid_right_bit;

                wire bot_left_bit = state_r[r_bot][(c==0)? SIZE-1 : c-1];
                wire bot_mid_bit  = state_r[r_bot][c];
                wire bot_right_bit= state_r[r_bot][(c==SIZE-1)? 0 : c+1];
                assign bot_partial_sums[r][c] = bot_left_bit + bot_mid_bit + bot_right_bit;
            end
        end
    endgenerate

    // Pipeline registers for partial sums (Stage 1 -> Stage 2)
    reg [1:0] sum_top_reg_2d [0:SIZE-1][0:SIZE-1];
    reg [1:0] sum_mid_reg_2d [0:SIZE-1][0:SIZE-1];
    reg [1:0] sum_bot_reg_2d [0:SIZE-1][0:SIZE-1];

    // Stage1 pipeline registers update
    always @(posedge clk) begin
        if (load) begin
            // On load, no meaningful partial sums, reset partial sums registers to zero
            for (i=0; i<SIZE; i=i+1) begin
                integer j;
                for (j=0; j<SIZE; j=j+1) begin
                    sum_top_reg_2d[i][j] <= 0;
                    sum_mid_reg_2d[i][j] <= 0;
                    sum_bot_reg_2d[i][j] <= 0;
                end
            end
        end else begin
            for (i=0; i<SIZE; i=i+1) begin
                integer j;
                for (j=0; j<SIZE; j=j+1) begin
                    sum_top_reg_2d[i][j] <= top_partial_sums[i][j];
                    sum_mid_reg_2d[i][j] <= mid_partial_sums[i][j];
                    sum_bot_reg_2d[i][j] <= bot_partial_sums[i][j];
                end
            end
        end
    end

    // Stage 2: sum partial sums and apply rules
    // Sum neighbors = sum_top + sum_mid + sum_bot per cell
    // sum range 0..8 fits in 4 bits, but max is 8, so 4 bits is safe

    reg [3:0] neighbor_sum [0:SIZE-1][0:SIZE-1];
    reg cell_state_bit [0:SIZE-1][0:SIZE-1];
    reg next_cell_state [0:SIZE-1][0:SIZE-1];

    integer rr, cc;
    always @(*) begin
        for (rr=0; rr<SIZE; rr=rr+1) begin
            for (cc=0; cc<SIZE; cc=cc+1) begin
                neighbor_sum[rr][cc] = sum_top_reg_2d[rr][cc] + sum_mid_reg_2d[rr][cc] + sum_bot_reg_2d[rr][cc];
                cell_state_bit[rr][cc] = state_r[rr][cc];
                // Apply game rules:
                // 0-1 neighbor: 0
                // 2 neighbors: keep current state
                // 3 neighbors: 1
                // 4+ neighbors: 0
                if (neighbor_sum[rr][cc] <= 1)
                    next_cell_state[rr][cc] = 1'b0;
                else if (neighbor_sum[rr][cc] == 2)
                    next_cell_state[rr][cc] = cell_state_bit[rr][cc];
                else if (neighbor_sum[rr][cc] == 3)
                    next_cell_state[rr][cc] = 1'b1;
                else
                    next_cell_state[rr][cc] = 1'b0;
            end
        end
    end

    // Flatten next_cell_state bits to next_state_r rows
    always @(*) begin
        integer rr2, cc2;
        for (rr2=0; rr2<SIZE; rr2=rr2+1) begin
            next_state_r[rr2] = 0;
            for (cc2=0; cc2<SIZE; cc2=cc2+1) begin
                next_state_r[rr2][cc2] = next_cell_state[rr2][cc2];
            end
        end
    end

    // Pack updated state rows into output vector q
    always @(*) begin
        integer rr3;
        q = 0;
        for (rr3=0; rr3<SIZE; rr3=rr3+1) begin
            q[rr3*SIZE +: SIZE] = state_r[rr3];
        end
    end

endmodule