module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid parameters
    localparam GRID_SIZE = 16;
    localparam TOTAL_CELLS = GRID_SIZE * GRID_SIZE;
    
    // Next state wire
    wire [255:0] next_q;
    
    // Neighbor counting and state update
    genvar i;
    generate
        for (i = 0; i < TOTAL_CELLS; i = i + 1) begin : cell_update
            // Calculate row and column indices
            wire [3:0] row = i / GRID_SIZE;
            wire [3:0] col = i % GRID_SIZE;
            
            // Calculate neighbor positions with toroidal wrapping
            wire [3:0] row_p = (row == 0) ? GRID_SIZE-1 : row-1;
            wire [3:0] row_n = (row == GRID_SIZE-1) ? 0 : row+1;
            wire [3:0] col_p = (col == 0) ? GRID_SIZE-1 : col-1;
            wire [3:0] col_n = (col == GRID_SIZE-1) ? 0 : col+1;
            
            // Neighbor indices (using shifts instead of multiplication)
            wire [7:0] n0 = {row_p, col_p};
            wire [7:0] n1 = {row_p, col};
            wire [7:0] n2 = {row_p, col_n};
            wire [7:0] n3 = {row, col_p};
            wire [7:0] n4 = {row, col_n};
            wire [7:0] n5 = {row_n, col_p};
            wire [7:0] n6 = {row_n, col};
            wire [7:0] n7 = {row_n, col_n};
            
            // Neighbor count (direct bit selection)
            wire [3:0] neighbor_count = 
                q[n0] + q[n1] + q[n2] + 
                q[n3] + q[n4] + 
                q[n5] + q[n6] + q[n7];
            
            // State transition rules
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                             (neighbor_count == 2) ? q[i] :
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