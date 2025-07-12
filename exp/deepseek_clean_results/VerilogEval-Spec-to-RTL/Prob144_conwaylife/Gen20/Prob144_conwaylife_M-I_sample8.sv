module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] q_ff;
    wire [255:0] next_q;
    wire [255:0] cell_update;
    wire [255:0] neighbor_changed;
    
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
                
                // Shared neighbor indices between adjacent cells
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Stage 1: Partial sums (registered to break critical path)
                reg [1:0] sum_top, sum_mid, sum_bot;
                always @(posedge clk) begin
                    sum_top <= q[n0] + q[n1] + q[n2];
                    sum_mid <= q[n3] + q[n4];
                    sum_bot <= q[n5] + q[n6] + q[n7];
                end
                
                // Stage 2: Final neighbor count
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Next state calculation
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                   (neighbor_count == 2) ? q_ff[idx] :
                                   1'b0;
                
                // Change detection
                assign neighbor_changed[idx] = |{q[n0], q[n1], q[n2], q[n3], q[n4], q[n5], q[n6], q[n7]};
                assign cell_update[idx] = load | (neighbor_changed[idx] & (next_q[idx] != q_ff[idx]));
            end
        end
    endgenerate

    // Sequential update with clock gating
    always @(posedge clk) begin
        q_ff <= q;  // Pipeline register for neighbor calculations
        
        for (integer i = 0; i < 256; i = i + 1) begin
            if (cell_update[i]) begin
                q[i] <= load ? data[i] : next_q[i];
            end
        end
    end

endmodule