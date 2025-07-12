module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    // Precompute row sums for neighbor sharing
    wire [15:0] row_sums [15:0];
    genvar row;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            assign row_sums[row] = q[row*16 +: 16];
        end
    endgenerate

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_loop
            for (j = 0; j < 16; j = j + 1) begin : col_loop
                // Efficient wrap-around using bitwise masking
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Shared neighbor calculations for 4x4 block
                wire [1:0] top_sum = row_sums[row_prev][col_prev] + 
                                    row_sums[row_prev][j] + 
                                    row_sums[row_prev][col_next];
                wire [1:0] mid_sum = q[i*16 + col_prev] + 
                                    q[i*16 + col_next];
                wire [1:0] bot_sum = row_sums[row_next][col_prev] + 
                                    row_sums[row_next][j] + 
                                    row_sums[row_next][col_next];
                
                // Hierarchical adder for neighbor count
                wire [3:0] neighbor_count = top_sum + mid_sum + bot_sum;
                
                // Stability detection and next state
                assign cell_stable[i*16 + j] = (neighbor_count == 4'd2) && q[i*16 + j];
                assign next_q[i*16 + j] = cell_stable[i*16 + j] ? q[i*16 + j] :
                                         (neighbor_count == 4'd3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Optimized sequential update with conditional changes
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (!cell_stable[k]) begin
                    q[k] <= next_q[k];
                end
            end
        end
    end

endmodule