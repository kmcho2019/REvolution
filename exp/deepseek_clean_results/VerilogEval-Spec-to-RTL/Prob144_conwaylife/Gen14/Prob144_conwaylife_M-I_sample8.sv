module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_state_ff;
    
    // Precompute row offsets for faster addressing
    wire [63:0] row_offsets;
    genvar r;
    generate
        for (r = 0; r < 16; r = r + 1) begin
            assign row_offsets[r*4 +: 4] = r * 16;
        end
    endgenerate

    // Stage 1: Neighbor counting
    wire [255:0][3:0] neighbor_counts;
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Neighbor indices with optimized wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Shared neighbor sums (carry-save style)
                wire [1:0] sum1 = q[row_offsets[row_prev*4 +: 4] + col_prev] + 
                                 q[row_offsets[row_prev*4 +: 4] + j] + 
                                 q[row_offsets[row_prev*4 +: 4] + col_next];
                wire [1:0] sum2 = q[row_offsets[i*4 +: 4] + col_prev] + 
                                 q[row_offsets[i*4 +: 4] + col_next];
                wire [1:0] sum3 = q[row_offsets[row_next*4 +: 4] + col_prev] + 
                                 q[row_offsets[row_next*4 +: 4] + j] + 
                                 q[row_offsets[row_next*4 +: 4] + col_next];
                
                // Pipeline stage 1: Store intermediate sums
                reg [1:0] sum1_ff, sum2_ff, sum3_ff;
                always @(posedge clk) begin
                    sum1_ff <= sum1;
                    sum2_ff <= sum2;
                    sum3_ff <= sum3;
                end
                
                // Stage 2: Final count and next state
                wire [3:0] count = sum1_ff + sum2_ff + sum3_ff;
                wire stable = (count == 2) && q_ff[i*16+j];
                wire birth = (count == 3);
                assign neighbor_counts[i*16+j] = stable ? q_ff[i*16+j] : birth;
            end
        end
    endgenerate

    // Stability detection and clock gating
    wire [255:0] cell_changes = q_ff ^ neighbor_counts;
    wire any_change = |cell_changes;

    // Optimized sequential update with clock gating
    always @(posedge clk) begin
        q_ff <= load ? data : q;
        
        if (load) begin
            q <= data;
        end else if (any_change) begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (cell_changes[k]) begin
                    q[k] <= neighbor_counts[k];
                end
            end
        end
    end

endmodule