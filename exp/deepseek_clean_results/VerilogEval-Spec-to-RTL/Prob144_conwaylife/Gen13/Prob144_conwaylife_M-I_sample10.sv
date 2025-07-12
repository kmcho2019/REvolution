module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_state_ff;
    wire [255:0] next_state;

    // Precompute row offsets for address calculation
    wire [3:0] row_offsets [0:15];
    genvar r;
    generate
        for (r = 0; r < 16; r = r + 1) begin : row_offset
            assign row_offsets[r] = r * 16;
        end
    endgenerate

    // Stage 1: Neighbor counting
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Neighbor indices with optimized wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;

                // Shared neighbor calculations
                wire nw = q_ff[row_offsets[row_prev] + col_prev];
                wire n  = q_ff[row_offsets[row_prev] + j];
                wire ne = q_ff[row_offsets[row_prev] + col_next];
                wire w  = q_ff[row_offsets[i] + col_prev];
                wire e  = q_ff[row_offsets[i] + col_next];
                wire sw = q_ff[row_offsets[row_next] + col_prev];
                wire s  = q_ff[row_offsets[row_next] + j];
                wire se = q_ff[row_offsets[row_next] + col_next];

                // Carry-save neighbor counting (3:2 compressor)
                wire [1:0] sum1 = nw + n + ne;
                wire [1:0] sum2 = w + e;
                wire [1:0] sum3 = sw + s + se;
                reg [3:0] count_ff;

                always @(posedge clk) begin
                    // Pipeline stage 1: Calculate neighbor counts
                    count_ff <= sum1 + sum2 + sum3;
                end

                // Stage 2: State update logic
                wire [3:0] count = count_ff;
                wire stable = (count == 2) && q_ff[row_offsets[i] + j];
                wire birth = (count == 3);
                assign next_state[row_offsets[i] + j] = stable ? q_ff[row_offsets[i] + j] : birth;
            end
        end
    endgenerate

    // Pipeline stage 2 registers
    always @(posedge clk) begin
        q_ff <= q;
        next_state_ff <= next_state;
    end

    // Final update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (next_state_ff[k] != q[k]) begin
                    q[k] <= next_state_ff[k];
                end
            end
        end
    end

endmodule