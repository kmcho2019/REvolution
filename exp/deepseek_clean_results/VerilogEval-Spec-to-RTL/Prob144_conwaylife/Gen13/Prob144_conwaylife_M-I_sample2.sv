module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;  // Indicates cells that won't change
    wire [255:0] cell_update;  // Indicates cells that need updating
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Shared neighbor position calculations
                localparam [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                localparam [3:0] row_next = (i == 15) ? 0 : (i + 1);
                localparam [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                localparam [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Shared neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Stage 1: Calculate row sums (parallel)
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                
                // Stage 2: Combine sums (registered if needed)
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Stability detection
                assign cell_stable[idx] = (neighbor_count == 2);
                
                // Next state calculation with optimized comparisons
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                    (cell_stable[idx]) ? q[idx] :
                                    1'b0;
                                    
                // Update signal (combines load and unstable cells)
                assign cell_update[idx] = load | ~cell_stable[idx];
            end
        end
    endgenerate

    // Optimized sequential update with clock gating
    always @(posedge clk) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            if (cell_update[i]) begin
                q[i] <= load ? data[i] : next_q[i];
            end
        end
    end

endmodule