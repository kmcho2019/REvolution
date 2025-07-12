module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;

    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_gen
            // Shared row calculations for all columns in this row
            localparam [3:0] row_prev = (row == 0) ? 15 : (row - 1);
            localparam [3:0] row_next = (row == 15) ? 0 : (row + 1);
            
            for (col = 0; col < 16; col = col + 1) begin : col_gen
                localparam idx = row*16 + col;
                
                // Shared column calculations
                localparam [3:0] col_prev = (col == 0) ? 15 : (col - 1);
                localparam [3:0] col_next = (col == 15) ? 0 : (col + 1);
                
                // Neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + col;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = row*16 + col_prev;
                localparam [7:0] n4 = row*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + col;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Optimized neighbor counting
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                
                // Final count with carry-save optimization
                wire [3:0] neighbor_count = {2'b0, sum_top} + {2'b0, sum_mid} + {2'b0, sum_bot};
                
                // Stability and next state
                assign cell_stable[idx] = (neighbor_count == 4'd2);
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                   (neighbor_count == 2) ? q[idx] :
                                   1'b0;
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that need to change
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule