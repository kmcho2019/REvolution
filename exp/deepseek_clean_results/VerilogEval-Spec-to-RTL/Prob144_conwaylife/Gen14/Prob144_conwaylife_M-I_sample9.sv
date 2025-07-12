module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor positions with wrap-around using modulo
                wire [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_next = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Get neighbor values
                wire [7:0] neighbors;
                assign neighbors[0] = q[row_prev*16 + col_prev]; // top-left
                assign neighbors[1] = q[row_prev*16 + j];        // top
                assign neighbors[2] = q[row_prev*16 + col_next]; // top-right
                assign neighbors[3] = q[i*16 + col_prev];        // left
                assign neighbors[4] = q[i*16 + col_next];        // right
                assign neighbors[5] = q[row_next*16 + col_prev]; // bottom-left
                assign neighbors[6] = q[row_next*16 + j];        // bottom
                assign neighbors[7] = q[row_next*16 + col_next]; // bottom-right
                
                // Optimized neighbor counting with balanced adder tree
                wire [1:0] sum_top = neighbors[0] + neighbors[1] + neighbors[2];
                wire [1:0] sum_mid = neighbors[3] + neighbors[4];
                wire [1:0] sum_bot = neighbors[5] + neighbors[6] + neighbors[7];
                wire [2:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Next state calculation
                assign next_q[i*16+j] = (neighbor_count == 3) ? 1'b1 :
                                      (neighbor_count == 2) ? q[i*16+j] :
                                      1'b0;
            end
        end
    endgenerate

    // Simplified sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule