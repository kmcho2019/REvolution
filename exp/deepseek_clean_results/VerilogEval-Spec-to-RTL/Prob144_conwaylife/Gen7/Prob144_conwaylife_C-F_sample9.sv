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
                // Efficient wrap-around using bitwise masking
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Neighbor indices
                wire [7:0] n0 = row_prev * 16 + col_prev;
                wire [7:0] n1 = row_prev * 16 + j;
                wire [7:0] n2 = row_prev * 16 + col_next;
                wire [7:0] n3 = i * 16 + col_prev;
                wire [7:0] n4 = i * 16 + col_next;
                wire [7:0] n5 = row_next * 16 + col_prev;
                wire [7:0] n6 = row_next * 16 + j;
                wire [7:0] n7 = row_next * 16 + col_next;
                
                // Carry-save neighbor counting (3-level adder tree)
                wire [1:0] sum_a = q[n0] + q[n1] + q[n2]; // Top row
                wire [1:0] sum_b = q[n3] + q[n4];         // Middle row
                wire [1:0] sum_c = q[n5] + q[n6] + q[n7]; // Bottom row
                wire [3:0] neighbor_count = sum_a + sum_b + sum_c;
                
                // Priority-encoded state update
                assign next_q[i*16+j] = (neighbor_count == 3) ? 1'b1 :
                                      (neighbor_count == 2) ? q[i*16+j] :
                                      1'b0;
            end
        end
    endgenerate

    // Optimized sequential update with conditional changes
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule