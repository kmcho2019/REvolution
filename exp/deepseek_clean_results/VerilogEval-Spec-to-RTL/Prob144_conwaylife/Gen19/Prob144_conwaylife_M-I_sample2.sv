module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_q_ff;
    wire [255:0] next_q;
    wire [255:0] cell_stable;

    // Clock gating signals
    wire [255:0] cell_update_en;

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
                
                // Shared neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Stage 1: Calculate neighbor sums (pipelined)
                reg [1:0] sum_top_ff, sum_mid_ff, sum_bot_ff;
                always @(posedge clk) begin
                    sum_top_ff <= q[n0] + q[n1] + q[n2];
                    sum_mid_ff <= q[n3] + q[n4];
                    sum_bot_ff <= q[n5] + q[n6] + q[n7];
                end
                
                // Stage 2: Final count and state calculation
                wire [3:0] neighbor_count = sum_top_ff + sum_mid_ff + sum_bot_ff;
                
                // Stability detection
                assign cell_stable[idx] = (neighbor_count == 2);
                assign cell_update_en[idx] = !cell_stable[idx] || load;
                
                // Next state calculation with optimized comparisons
                assign next_q[idx] = (neighbor_count == 3) | 
                                    ((neighbor_count == 2) & q_ff[idx]);
            end
        end
    endgenerate

    // Sequential logic with clock gating
    always @(posedge clk) begin
        q_ff <= q;
        
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (cell_update_en[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule