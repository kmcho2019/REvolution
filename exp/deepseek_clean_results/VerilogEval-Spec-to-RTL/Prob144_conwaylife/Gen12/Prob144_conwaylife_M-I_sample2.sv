module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    reg [255:0] prev_q;
    wire [255:0] changed;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Efficient wrap-around using bitwise masking
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Neighbor indices using shift instead of multiply
                wire [7:0] n0 = {row_prev, col_prev};
                wire [7:0] n1 = {row_prev, j[3:0]};
                wire [7:0] n2 = {row_prev, col_next};
                wire [7:0] n3 = {i[3:0], col_prev};
                wire [7:0] n4 = {i[3:0], col_next};
                wire [7:0] n5 = {row_next, col_prev};
                wire [7:0] n6 = {row_next, j[3:0]};
                wire [7:0] n7 = {row_next, col_next};
                
                // Carry-lookahead neighbor counting
                wire [1:0] sum_a = q[n0] + q[n1];
                wire [1:0] sum_b = q[n2] + q[n3];
                wire [1:0] sum_c = q[n4] + q[n5];
                wire [1:0] sum_d = q[n6] + q[n7];
                
                wire [2:0] sum_ab = sum_a + sum_b;
                wire [2:0] sum_cd = sum_c + sum_d;
                wire [3:0] neighbor_count = sum_ab + sum_cd;
                
                // Stability detection
                assign changed[i*16+j] = (neighbor_count == 3) ? 1'b1 :
                                       (neighbor_count == 2) ? q[i*16+j] != prev_q[i*16+j] :
                                        q[i*16+j] != 1'b0;
                
                // State update with clock gating
                always @(*) begin
                    if (changed[i*16+j]) begin
                        next_q[i*16+j] = (neighbor_count == 3) ? 1'b1 :
                                         (neighbor_count == 2) ? q[i*16+j] :
                                         1'b0;
                    end else begin
                        next_q[i*16+j] = q[i*16+j];
                    end
                end
            end
        end
    endgenerate

    // Sequential update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            prev_q <= data;
        end else begin
            prev_q <= q;
            q <= next_q;
        end
    end

endmodule