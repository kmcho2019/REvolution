module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    // Combinational next state calculation
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            // Calculate row and column indices
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            
            // Calculate neighbor positions with wrap-around
            wire [3:0] row_p1 = (row == 15) ? 4'd0 : row + 4'd1;
            wire [3:0] row_m1 = (row == 0) ? 4'd15 : row - 4'd1;
            wire [3:0] col_p1 = (col == 15) ? 4'd0 : col + 4'd1;
            wire [3:0] col_m1 = (col == 0) ? 4'd15 : col - 4'd1;
            
            // Get all 8 neighbors
            wire [7:0] neighbors = {
                q[{row_p1, col_p1}],  // SE
                q[{row_p1, col}],     // S
                q[{row_p1, col_m1}],  // SW
                q[{row, col_p1}],     // E
                q[{row, col_m1}],     // W
                q[{row_m1, col_p1}],  // NE
                q[{row_m1, col}],     // N
                q[{row_m1, col_m1}]   // NW
            };
            
            // Count live neighbors
            wire [3:0] neighbor_count = 
                neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            
            // Current cell state
            wire current_cell = q[i];
            
            // Next state logic
            assign next_q[i] = (neighbor_count == 4'd3) ? 1'b1 :
                             (neighbor_count == 4'd2) ? current_cell :
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