module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices with bit masking
            localparam row = i >> 4;      // i / 16
            localparam col = i & 15;      // i % 16
            
            // Pre-calculate neighbor row offsets (wrapped using &15)
            wire [3:0] row_above = (row + 15) & 15;
            wire [3:0] row_below = (row + 1) & 15;
            wire [3:0] col_left = (col + 15) & 15;
            wire [3:0] col_right = (col + 1) & 15;
            
            // Compute neighbor positions
            wire [7:0] neighbors;
            assign neighbors[0] = q[{row_above, 4'b0} + col_left];   // top-left
            assign neighbors[1] = q[{row_above, 4'b0} + col];       // top
            assign neighbors[2] = q[{row_above, 4'b0} + col_right];  // top-right
            assign neighbors[3] = q[{row, 4'b0} + col_left];        // left
            assign neighbors[4] = q[{row, 4'b0} + col_right];       // right
            assign neighbors[5] = q[{row_below, 4'b0} + col_left];  // bottom-left
            assign neighbors[6] = q[{row_below, 4'b0} + col];       // bottom
            assign neighbors[7] = q[{row_below, 4'b0} + col_right]; // bottom-right
            
            // Count live neighbors (sum of 8 bits fits in 4 bits)
            wire [3:0] neighbor_count;
            assign neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                                   neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            
            // Apply game rules
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              (neighbor_count == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule