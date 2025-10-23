module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_changes;  // Indicates cells that will change state
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor positions with optimized wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Get neighbor values
                wire [7:0] neighbors;
                assign neighbors[0] = q[row_prev*16 + col_prev]; // top-left
                assign neighbors[1] = q[row_prev*16 + j];         // top
                assign neighbors[2] = q[row_prev*16 + col_next];  // top-right
                assign neighbors[3] = q[i*16 + col_prev];        // left
                assign neighbors[4] = q[i*16 + col_next];         // right
                assign neighbors[5] = q[row_next*16 + col_prev];  // bottom-left
                assign neighbors[6] = q[row_next*16 + j];         // bottom
                assign neighbors[7] = q[row_next*16 + col_next];  // bottom-right
                
                // Optimized neighbor counting with carry-save
                wire [1:0] sum_top = neighbors[0] + neighbors[1] + neighbors[2];
                wire [1:0] sum_mid = neighbors[3] + neighbors[4];
                wire [1:0] sum_bot = neighbors[5] + neighbors[6] + neighbors[7];
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Next state calculation
                wire next_state = (neighbor_count == 3) ? 1'b1 :
                                 (neighbor_count == 2) ? q[i*16+j] :
                                 1'b0;
                
                assign next_q[i*16+j] = next_state;
                assign cell_changes[i*16+j] = (next_state != q[i*16+j]);
            end
        end
    endgenerate

    // Optimized sequential update with minimal changes
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that will change state
            for (integer k = 0; k < 256; k = k + 1) begin
                if (cell_changes[k]) begin
                    q[k] <= next_q[k];
                end
            end
        end
    end

endmodule