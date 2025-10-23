module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic
    wire [255:0] next_q;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Optimized neighbor index calculation using bitwise wrapping
                localparam n_row_prev = (i == 0) ? 15 : (i - 1);
                localparam n_row_next = (i == 15) ? 0 : (i + 1);
                localparam n_col_prev = (j == 0) ? 15 : (j - 1);
                localparam n_col_next = (j == 15) ? 0 : (j + 1);
                
                // Pre-compute all neighbor positions
                localparam [7:0] n0 = n_row_prev*16 + n_col_prev; // NW
                localparam [7:0] n1 = n_row_prev*16 + j;          // N
                localparam [7:0] n2 = n_row_prev*16 + n_col_next; // NE
                localparam [7:0] n3 = i*16 + n_col_prev;          // W
                localparam [7:0] n4 = i*16 + n_col_next;          // E
                localparam [7:0] n5 = n_row_next*16 + n_col_prev; // SW
                localparam [7:0] n6 = n_row_next*16 + j;          // S
                localparam [7:0] n7 = n_row_next*16 + n_col_next; // SE
                
                // Balanced adder tree for neighbor counting
                wire [3:0] neighbor_count;
                assign neighbor_count = 
                    (q[n0] + q[n1]) + (q[n2] + q[n3]) + 
                    (q[n4] + q[n5]) + (q[n6] + q[n7]);
                
                // State update rules implemented as case statement
                always @(*) begin
                    case (neighbor_count)
                        4'd2: next_q[idx] = q[idx];
                        4'd3: next_q[idx] = 1'b1;
                        default: next_q[idx] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Synchronous state update with load
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule