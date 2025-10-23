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
                // Calculate neighbor positions with bit masking
                wire [3:0] row_prev = row - 4'b1;
                wire [3:0] row_next = row + 4'b1;
                wire [3:0] col_prev = col - 4'b1;
                wire [3:0] col_next = col + 4'b1;
                
                // Get neighbor cells
                wire n0 = q[{row_prev[3:0], col_prev[3:0]}];
                wire n1 = q[{row_prev[3:0], col[3:0]}];
                wire n2 = q[{row_prev[3:0], col_next[3:0]}];
                wire n3 = q[{row[3:0], col_prev[3:0]}];
                wire n4 = q[{row[3:0], col_next[3:0]}];
                wire n5 = q[{row_next[3:0], col_prev[3:0]}];
                wire n6 = q[{row_next[3:0], col[3:0]}];
                wire n7 = q[{row_next[3:0], col_next[3:0]}];
                
                // Simple neighbor counting
                wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;
                
                // Next state calculation
                assign next_q[row*16 + col] = (neighbor_count == 4'd3) ? 1'b1 :
                                             (neighbor_count == 4'd2) ? q[row*16 + col] :
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