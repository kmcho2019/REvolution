module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    // Neighbor counting and next state calculation
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            // Calculate row and column indices
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            
            // Get neighbor positions with wrap-around
            wire [3:0] row_prev = (row == 0) ? 15 : (row - 1);
            wire [3:0] row_next = (row == 15) ? 0 : (row + 1);
            wire [3:0] col_prev = (col == 0) ? 15 : (col - 1);
            wire [3:0] col_next = (col == 15) ? 0 : (col + 1);
            
            // Extract all 8 neighbors
            wire nw = q[{row_prev, col_prev}];
            wire n  = q[{row_prev, col}];
            wire ne = q[{row_prev, col_next}];
            wire w  = q[{row, col_prev}];
            wire e  = q[{row, col_next}];
            wire sw = q[{row_next, col_prev}];
            wire s  = q[{row_next, col}];
            wire se = q[{row_next, col_next}];
            
            // Count live neighbors
            wire [3:0] neighbor_count = nw + n + ne + w + e + sw + s + se;
            
            // Current cell state
            wire current = q[i];
            
            // Next state logic
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              (neighbor_count == 2) ? current :
                              1'b0;
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule