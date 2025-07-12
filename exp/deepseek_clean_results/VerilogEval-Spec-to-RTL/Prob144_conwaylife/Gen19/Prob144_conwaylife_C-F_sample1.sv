module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_changes;

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Efficient wrap-around using bitwise masking
                wire [3:0] row_prev = (i - 1) & 15;
                wire [3:0] row_next = (i + 1) & 15;
                wire [3:0] col_prev = (j - 1) & 15;
                wire [3:0] col_next = (j + 1) & 15;
                
                // Neighbor indices
                wire [7:0] n0 = row_prev*16 + col_prev;
                wire [7:0] n1 = row_prev*16 + j;
                wire [7:0] n2 = row_prev*16 + col_next;
                wire [7:0] n3 = i*16 + col_prev;
                wire [7:0] n4 = i*16 + col_next;
                wire [7:0] n5 = row_next*16 + col_prev;
                wire [7:0] n6 = row_next*16 + j;
                wire [7:0] n7 = row_next*16 + col_next;
                
                // Parallel neighbor counting with carry-save
                wire [2:0] sum_top = {1'b0, q[n0]} + {1'b0, q[n1]} + {1'b0, q[n2]};
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [2:0] sum_bot = {1'b0, q[n5]} + {1'b0, q[n6]} + {1'b0, q[n7]};
                
                // Final sum with carry propagation
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Optimized next state calculation
                wire next_state = (neighbor_count == 3) ? 1'b1 :
                                  (neighbor_count == 2) ? q[idx] :
                                  1'b0;
                
                assign next_q[idx] = next_state;
                assign cell_changes[idx] = (next_state != q[idx]);
            end
        end
    endgenerate

    // Conditional updates only for changing cells
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (cell_changes[k]) begin
                    q[k] <= next_q[k];
                end
            end
        end
    end

endmodule