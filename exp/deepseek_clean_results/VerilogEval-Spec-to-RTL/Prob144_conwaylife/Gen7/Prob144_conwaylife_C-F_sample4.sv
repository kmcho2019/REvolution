module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_stable;  // Indicates cells that won't change
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Calculate neighbor positions with optimized wrap-around
                localparam [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                localparam [3:0] row_next = (i == 15) ? 0 : (i + 1);
                localparam [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                localparam [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Pre-compute all neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev; // top-left
                localparam [7:0] n1 = row_prev*16 + j;       // top
                localparam [7:0] n2 = row_prev*16 + col_next; // top-right
                localparam [7:0] n3 = i*16 + col_prev;        // left
                localparam [7:0] n4 = i*16 + col_next;        // right
                localparam [7:0] n5 = row_next*16 + col_prev; // bottom-left
                localparam [7:0] n6 = row_next*16 + j;        // bottom
                localparam [7:0] n7 = row_next*16 + col_next; // bottom-right
                
                // Optimized neighbor counting
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Stability detection
                assign cell_stable[idx] = (neighbor_count == 2);
                
                // Next state calculation
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                     (neighbor_count == 2) ? q[idx] :
                                     1'b0;
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that aren't stable
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule