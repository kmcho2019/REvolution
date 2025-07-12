module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state computation
    wire [255:0] next_q;
    
    // Generate neighbor counting and next state logic for each cell
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell
            // Calculate row and column indices (0-15)
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            
            // Calculate neighbor positions with toroidal wrapping
            wire [3:0] row_m1 = (row == 4'd0) ? 4'd15 : (row - 4'd1);
            wire [3:0] row_p1 = (row == 4'd15) ? 4'd0 : (row + 4'd1);
            wire [3:0] col_m1 = (col == 4'd0) ? 4'd15 : (col - 4'd1);
            wire [3:0] col_p1 = (col == 4'd15) ? 4'd0 : (col + 4'd1);
            
            // Neighbor bit positions
            wire [7:0] neighbor_bits = {
                q[{row_m1, col_m1}], q[{row_m1, col}], q[{row_m1, col_p1}],
                q[{row,   col_m1}],                     q[{row,   col_p1}],
                q[{row_p1, col_m1}], q[{row_p1, col}], q[{row_p1, col_p1}]
            };
            
            // Count live neighbors
            wire [3:0] neighbor_count;
            assign neighbor_count = neighbor_bits[0] + neighbor_bits[1] + neighbor_bits[2] + 
                                  neighbor_bits[3] + neighbor_bits[4] + neighbor_bits[5] + 
                                  neighbor_bits[6] + neighbor_bits[7];
            
            // Compute next state
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                             ((neighbor_count == 2) ? q[i] : 1'b0);
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