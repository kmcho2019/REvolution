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
            // Calculate row and column indices
            localparam row = i / 16;
            localparam col = i % 16;
            
            // Calculate neighbor positions with wrap-around
            wire [3:0] row_prev = (row == 0) ? 15 : (row - 1);
            wire [3:0] row_next = (row == 15) ? 0 : (row + 1);
            wire [3:0] col_prev = (col == 0) ? 15 : (col - 1);
            wire [3:0] col_next = (col == 15) ? 0 : (col + 1);
            
            // Get neighbor values
            wire [7:0] neighbors;
            assign neighbors[0] = q[row_prev*16 + col_prev]; // top-left
            assign neighbors[1] = q[row_prev*16 + col];      // top
            assign neighbors[2] = q[row_prev*16 + col_next]; // top-right
            assign neighbors[3] = q[row*16 + col_prev];      // left
            assign neighbors[4] = q[row*16 + col_next];      // right
            assign neighbors[5] = q[row_next*16 + col_prev]; // bottom-left
            assign neighbors[6] = q[row_next*16 + col];       // bottom
            assign neighbors[7] = q[row_next*16 + col_next]; // bottom-right
            
            // Count live neighbors
            wire [3:0] neighbor_count = 
                neighbors[0] + neighbors[1] + neighbors[2] +
                neighbors[3] + neighbors[4] +
                neighbors[5] + neighbors[6] + neighbors[7];
            
            // Next state calculation
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