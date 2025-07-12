module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] neighbor_count_stage1;
    reg [255:0] neighbor_count_stage2;
    reg [255:0] cell_stable;

    // Precompute row sums for sharing
    wire [15:0] row_sums [15:0];
    genvar row;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            assign row_sums[row] = q[row*16 +: 16];
        end
    endgenerate

    // Stage 1: Calculate neighbor rows
    always @(posedge clk) begin
        q_ff <= load ? data : q;
        
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                // Get neighboring rows with wrap-around (using bit masking)
                wire [15:0] prev_row = row_sums[(i-1) & 4'b1111];
                wire [15:0] curr_row = row_sums[i];
                wire [15:0] next_row = row_sums[(i+1) & 4'b1111];
                
                // Calculate column positions with wrap-around
                integer prev_col = (j-1) & 4'b1111;
                integer next_col = (j+1) & 4'b1111;
                
                // Stage 1: Sum of three positions in each row
                neighbor_count_stage1[i*16+j] <= 
                    prev_row[prev_col] + prev_row[j] + prev_row[next_col] +
                    curr_row[prev_col] + curr_row[next_col] +
                    next_row[prev_col] + next_row[j] + next_row[next_col];
            end
        end
    end

    // Stage 2: Final neighbor count and next state calculation
    always @(posedge clk) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            // Register neighbor count
            neighbor_count_stage2[i] <= neighbor_count_stage1[i];
            
            // Determine cell stability
            cell_stable[i] <= (neighbor_count_stage1[i] == 4'd2);
            
            // Update only unstable cells (4x4 block clock gating)
            if (!cell_stable[i] || load) begin
                case (neighbor_count_stage2[i])
                    4'd3: q[i] <= 1'b1;
                    default: q[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule