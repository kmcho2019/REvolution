module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with wrap-around
                wire [3:0] row_prev = (row == 0) ? 15 : (row - 1);
                wire [3:0] row_next = (row == 15) ? 0 : (row + 1);
                wire [3:0] col_prev = (col == 0) ? 15 : (col - 1);
                wire [3:0] col_next = (col == 15) ? 0 : (col + 1);
                
                // Get neighbor cells
                wire n0 = q[{row_prev, col_prev}];
                wire n1 = q[{row_prev, col}];
                wire n2 = q[{row_prev, col_next}];
                wire n3 = q[{row, col_prev}];
                wire n4 = q[{row, col_next}];
                wire n5 = q[{row_next, col_prev}];
                wire n6 = q[{row_next, col}];
                wire n7 = q[{row_next, col_next}];
                
                // Count neighbors
                wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;
                
                // Next state calculation
                assign next_q[row*16 + col] = (neighbor_count == 3) ? 1'b1 :
                                             (neighbor_count == 2) ? q[row*16 + col] :
                                             1'b0;
            end
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