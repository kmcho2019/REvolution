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
            // Shared row calculations for all columns in this row
            localparam [3:0] row_prev = (i-1) & 15;
            localparam [3:0] row_next = (i+1) & 15;
            
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Shared column calculations
                localparam [3:0] col_prev = (j-1) & 15;
                localparam [3:0] col_next = (j+1) & 15;
                
                // Neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Optimized neighbor counting
                wire [2:0] sum_top = {1'b0, q[n0]} + {1'b0, q[n1]} + {1'b0, q[n2]};
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [2:0] sum_bot = {1'b0, q[n5]} + {1'b0, q[n6]} + {1'b0, q[n7]};
                wire [3:0] neighbor_count = sum_top + sum_bot + {2'b0, sum_mid};
                
                // Stability detection and next state
                wire stable = (neighbor_count == 2) & q[idx];
                wire birth = (neighbor_count == 3);
                assign next_q[idx] = stable ? q[idx] : birth;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule