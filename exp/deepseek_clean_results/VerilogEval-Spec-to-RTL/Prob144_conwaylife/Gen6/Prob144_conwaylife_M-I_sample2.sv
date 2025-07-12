module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic with clock gating
    wire [255:0] next_q;
    wire [255:0] cell_change;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Simplified neighbor index calculation using bitwise wrapping
                wire [7:0] row_above = {i[3:0],3'b0} + {3'b0,j[3:0]} - 16'd1;
                wire [7:0] row_below = {i[3:0],3'b0} + {3'b0,j[3:0]} + 16'd1;
                wire [7:0] col_left = {3'b0,j[3:0]} - 16'd1;
                wire [7:0] col_right = {3'b0,j[3:0]} + 16'd1;
                
                // Neighbor positions (only 4 unique calculations shared between cells)
                wire [7:0] n0 = row_above[7:4]*16 + col_left[3:0];  // top-left
                wire [7:0] n1 = row_above[7:4]*16 + j;               // top
                wire [7:0] n2 = row_above[7:4]*16 + col_right[3:0];  // top-right
                wire [7:0] n3 = i*16 + col_left[3:0];                // left
                wire [7:0] n4 = i*16 + col_right[3:0];               // right
                wire [7:0] n5 = row_below[7:4]*16 + col_left[3:0];   // bottom-left
                wire [7:0] n6 = row_below[7:4]*16 + j;               // bottom
                wire [7:0] n7 = row_below[7:4]*16 + col_right[3:0];  // bottom-right
                
                // Pipelined neighbor counting (split into two stages)
                wire [1:0] count_stage1 = q[n0] + q[n1] + q[n2] + q[n3];
                wire [1:0] count_stage2 = q[n4] + q[n5] + q[n6] + q[n7];
                wire [2:0] neighbor_count = count_stage1 + count_stage2;
                
                // State update with clock gating
                assign cell_change[idx] = (neighbor_count != 3'd2);
                assign next_q[idx] = (neighbor_count == 3'd3) ? 1'b1 :
                                   (neighbor_count == 3'd2) ? q[idx] :
                                   1'b0;
            end
        end
    endgenerate

    // Synchronous state update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (cell_change[k]) begin
                    q[k] <= next_q[k];
                end
            end
        end
    end

endmodule