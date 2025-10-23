module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    reg [255:0] neighbor_count;
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices
            localparam row = i / 16;
            localparam col = i % 16;
            
            // Calculate neighbor positions with hybrid wrap-around
            wire [3:0] row_prev = (row - 1) & 15;
            wire [3:0] row_next = (row + 1) & 15;
            wire [3:0] col_prev = (col - 1) & 15;
            wire [3:0] col_next = (col + 1) & 15;
            
            // Get neighbor values - pipelined for timing
            reg [7:0] neighbors;
            always @(posedge clk) begin
                neighbors[0] <= q[row_prev*16 + col_prev]; // top-left
                neighbors[1] <= q[row_prev*16 + col];      // top
                neighbors[2] <= q[row_prev*16 + col_next]; // top-right
                neighbors[3] <= q[row*16 + col_prev];      // left
                neighbors[4] <= q[row*16 + col_next];      // right
                neighbors[5] <= q[row_next*16 + col_prev]; // bottom-left
                neighbors[6] <= q[row_next*16 + col];      // bottom
                neighbors[7] <= q[row_next*16 + col_next]; // bottom-right
            end
            
            // Pipelined neighbor counting
            reg [1:0] sum_top, sum_mid, sum_bot;
            always @(posedge clk) begin
                sum_top <= neighbors[0] + neighbors[1] + neighbors[2];
                sum_mid <= neighbors[3] + neighbors[4];
                sum_bot <= neighbors[5] + neighbors[6] + neighbors[7];
                neighbor_count[i] <= sum_top + sum_mid + sum_bot;
            end
            
            // Next state calculation with stability detection
            assign next_q[i] = (neighbor_count[i] == 3) ? 1'b1 :
                              ((neighbor_count[i] == 2) && q[i]) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Optimized sequential update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (next_q[i] != q[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule