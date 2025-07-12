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
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Shared neighbor position calculations
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
                
                // Parallel neighbor counting using carry-save
                wire [2:0] sum_top = {1'b0, q[n0]} + {1'b0, q[n1]} + {1'b0, q[n2]};
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [2:0] sum_bot = {1'b0, q[n5]} + {1'b0, q[n6]} + {1'b0, q[n7]};
                
                // Final sum with carry propagation
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Optimized next state calculation
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                    (neighbor_count == 2) ? q[idx] :
                                    1'b0;
            end
        end
    endgenerate

    // Simplified sequential update (no dynamic clock gating)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule