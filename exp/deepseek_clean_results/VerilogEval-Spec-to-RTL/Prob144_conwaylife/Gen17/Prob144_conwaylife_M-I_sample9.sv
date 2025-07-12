module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            // Precompute row indices for sharing
            localparam [3:0] row_prev = (i == 0) ? 15 : (i - 1);
            localparam [3:0] row_next = (i == 15) ? 0 : (i + 1);
            
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Shared column indices
                localparam [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                localparam [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Neighbor indices (shared where possible)
                wire [7:0] n0 = row_prev*16 + col_prev;
                wire [7:0] n1 = row_prev*16 + j;
                wire [7:0] n2 = row_prev*16 + col_next;
                wire [7:0] n3 = i*16 + col_prev;
                wire [7:0] n4 = i*16 + col_next;
                wire [7:0] n5 = row_next*16 + col_prev;
                wire [7:0] n6 = row_next*16 + j;
                wire [7:0] n7 = row_next*16 + col_next;
                
                // Parallel neighbor counting using Kogge-Stone structure
                wire [1:0] sum_a = q[n0] + q[n1];
                wire [1:0] sum_b = q[n2] + q[n3];
                wire [1:0] sum_c = q[n4] + q[n5];
                wire [1:0] sum_d = q[n6] + q[n7];
                
                wire [2:0] sum_ab = sum_a + sum_b;
                wire [2:0] sum_cd = sum_c + sum_d;
                
                wire [3:0] neighbor_count = sum_ab + sum_cd;
                
                // Optimized state transition with early termination
                wire cell_stable = (neighbor_count == 2);
                wire cell_born = (neighbor_count == 3);
                
                assign next_q[idx] = cell_stable ? q[idx] : 
                                   cell_born ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Sequential update with optimized clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule