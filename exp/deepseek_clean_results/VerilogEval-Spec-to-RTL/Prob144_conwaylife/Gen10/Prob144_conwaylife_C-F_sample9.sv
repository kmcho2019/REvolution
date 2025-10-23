module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] update_mask;  // Mask for cells that need updating
    
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
                
                // Optimized neighbor counting with carry-save
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                
                // Final count with carry-save adder
                wire [2:0] temp_sum = sum_top + sum_mid;
                wire [3:0] neighbor_count = temp_sum + sum_bot;
                
                // Next state and update mask calculation
                wire current = q[idx];
                wire next_state = (neighbor_count == 3) ? 1'b1 :
                                 (neighbor_count == 2) ? current :
                                 1'b0;
                
                assign next_q[idx] = next_state;
                assign update_mask[idx] = (next_state != current);
            end
        end
    endgenerate

    // Optimized sequential update with masking
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells marked in update_mask
            for (integer i = 0; i < 256; i = i + 1) begin
                if (update_mask[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule