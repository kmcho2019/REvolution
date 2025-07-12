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
                wire [3:0] row_m1 = (row == 0) ? 15 : row - 1;
                wire [3:0] row_p1 = (row == 15) ? 0 : row + 1;
                wire [3:0] col_m1 = (col == 0) ? 15 : col - 1;
                wire [3:0] col_p1 = (col == 15) ? 0 : col + 1;

                // Count all 8 neighbors
                wire [3:0] neighbor_count = 
                    q[row_m1*16 + col_m1] + q[row_m1*16 + col] + q[row_m1*16 + col_p1] +
                    q[row*16 + col_m1] + q[row*16 + col_p1] +
                    q[row_p1*16 + col_m1] + q[row_p1*16 + col] + q[row_p1*16 + col_p1];

                // Next state logic
                assign next_q[row*16 + col] = 
                    (neighbor_count == 3) ? 1'b1 :
                    (neighbor_count == 2) ? q[row*16 + col] :
                    1'b0;
            end
        end
    endgenerate

    // Simple sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule