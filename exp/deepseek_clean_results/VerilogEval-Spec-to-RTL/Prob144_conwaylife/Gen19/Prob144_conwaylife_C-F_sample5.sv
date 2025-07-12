module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_update;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Optimized neighbor position calculations with bitwise wrap
                localparam [3:0] row_prev = (i - 1) & 15;
                localparam [3:0] row_next = (i + 1) & 15;
                localparam [3:0] col_prev = (j - 1) & 15;
                localparam [3:0] col_next = (j + 1) & 15;
                
                // Shared neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Stage 1: Carry-save addition for neighbor sums
                wire [2:0] sum_top = {1'b0, q[n0]} + {1'b0, q[n1]} + {1'b0, q[n2]};
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [2:0] sum_bot = {1'b0, q[n5]} + {1'b0, q[n6]} + {1'b0, q[n7]};
                
                // Stage 2: Final neighbor count with optimized addition
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Next state calculation with stability detection
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                   (neighbor_count == 2) ? q[idx] :
                                   1'b0;
                
                // Update signal (combines load and unstable cells)
                assign cell_update[idx] = load | (next_q[idx] != q[idx]);
            end
        end
    endgenerate

    // Optimized sequential update with efficient conditional updates
    always @(posedge clk) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            if (cell_update[i]) begin
                q[i] <= load ? data[i] : next_q[i];
            end
        end
    end

endmodule