module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer i;
    
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            // Calculate row and column indices
            integer row = i >> 4;      // i / 16
            integer col = i & 15;      // i % 16
            
            // Compute neighbor positions with wrapping using bitwise AND
            integer row_m1 = (row + 15) & 15;  // row-1 with wrap
            integer row_p1 = (row + 1) & 15;   // row+1 with wrap
            integer col_m1 = (col + 15) & 15;  // col-1 with wrap
            integer col_p1 = (col + 1) & 15;   // col+1 with wrap
            
            // Get all 8 neighbors
            wire [7:0] neighbors = {
                q[row_m1*16 + col_m1],  // top-left
                q[row_m1*16 + col],     // top
                q[row_m1*16 + col_p1],  // top-right
                q[row*16 + col_m1],    // left
                q[row*16 + col_p1],    // right
                q[row_p1*16 + col_m1], // bottom-left
                q[row_p1*16 + col],    // bottom
                q[row_p1*16 + col_p1]  // bottom-right
            };
            
            // Count live neighbors using reduction operator
            wire [3:0] neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                                       neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            
            // Apply game rules
            next_q[i] = (neighbor_count == 3) ? 1'b1 :
                        (neighbor_count == 2) ? q[i] :
                        1'b0;
        end
    end

    // State update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule