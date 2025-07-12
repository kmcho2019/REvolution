module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    // Precompute row offsets for neighbor calculations
    wire [255:0] row_prev, row_next;
    wire [255:0] col_prev, col_next;
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices with wrap-around
            localparam row = i / 16;
            localparam col = i % 16;
            
            // Neighbor positions with efficient wrap-around
            assign row_prev[i] = (row - 1) & 15;
            assign row_next[i] = (row + 1) & 15;
            assign col_prev[i] = (col - 1) & 15;
            assign col_next[i] = (col + 1) & 15;
            
            // Get neighbor values
            wire [7:0] neighbors;
            assign neighbors[0] = q[row_prev[i]*16 + col_prev[i]]; // top-left
            assign neighbors[1] = q[row_prev[i]*16 + col];         // top
            assign neighbors[2] = q[row_prev[i]*16 + col_next[i]]; // top-right
            assign neighbors[3] = q[row*16 + col_prev[i]];        // left
            assign neighbors[4] = q[row*16 + col_next[i]];         // right
            assign neighbors[5] = q[row_next[i]*16 + col_prev[i]]; // bottom-left
            assign neighbors[6] = q[row_next[i]*16 + col];         // bottom
            assign neighbors[7] = q[row_next[i]*16 + col_next[i]]; // bottom-right
            
            // Optimized neighbor counting with carry-save
            wire [1:0] sum_top = neighbors[0] + neighbors[1] + neighbors[2];
            wire [1:0] sum_mid = neighbors[3] + neighbors[4];
            wire [1:0] sum_bot = neighbors[5] + neighbors[6] + neighbors[7];
            wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
            
            // Combined stability detection and next state calculation
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              ((neighbor_count == 2) ? q[i] : 1'b0);
        end
    endgenerate

    // Efficient sequential update with minimal conditional changes
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                // Only update if state will change
                if (next_q[i] !== q[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule