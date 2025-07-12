module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;  // Indicates cells with exactly 2 neighbors
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices
            localparam row = i / 16;
            localparam col = i % 16;
            
            // Calculate neighbor positions with optimized wrap-around
            wire [3:0] row_prev = (row == 0) ? 15 : (row - 1);
            wire [3:0] row_next = (row == 15) ? 0 : (row + 1);
            wire [3:0] col_prev = (col == 0) ? 15 : (col - 1);
            wire [3:0] col_next = (col == 15) ? 0 : (col + 1);
            
            // Get neighbor values
            wire [7:0] neighbors;
            assign neighbors[0] = q[row_prev*16 + col_prev]; // top-left
            assign neighbors[1] = q[row_prev*16 + col];      // top
            assign neighbors[2] = q[row_prev*16 + col_next]; // top-right
            assign neighbors[3] = q[row*16 + col_prev];     // left
            assign neighbors[4] = q[row*16 + col_next];      // right
            assign neighbors[5] = q[row_next*16 + col_prev]; // bottom-left
            assign neighbors[6] = q[row_next*16 + col];      // bottom
            assign neighbors[7] = q[row_next*16 + col_next]; // bottom-right
            
            // Optimized neighbor counting
            wire [1:0] sum_top = neighbors[0] + neighbors[1] + neighbors[2];
            wire [1:0] sum_mid = neighbors[3] + neighbors[4];
            wire [1:0] sum_bot = neighbors[5] + neighbors[6] + neighbors[7];
            wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
            
            // Stability detection
            assign cell_stable[i] = (neighbor_count == 4'd2);
            
            // Next state calculation
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                               (neighbor_count == 2) ? q[i] :
                               1'b0;
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that aren't stable
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule