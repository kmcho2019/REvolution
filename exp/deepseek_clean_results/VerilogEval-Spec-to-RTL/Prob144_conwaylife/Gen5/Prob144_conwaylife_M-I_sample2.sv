module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to pre-compute neighbor indices
    function [7:0][7:0] get_neighbors;
        input [7:0] idx;
        integer row, col;
        begin
            row = idx / 16;
            col = idx % 16;
            // Pre-compute all 8 neighbor positions with toroidal wrapping
            get_neighbors[0] = ((row+15)%16)*16 + ((col+15)%16); // top-left
            get_neighbors[1] = ((row+15)%16)*16 + col;           // top
            get_neighbors[2] = ((row+15)%16)*16 + ((col+1)%16);  // top-right
            get_neighbors[3] = row*16 + ((col+15)%16);           // left
            get_neighbors[4] = row*16 + ((col+1)%16);            // right
            get_neighbors[5] = ((row+1)%16)*16 + ((col+15)%16);  // bottom-left
            get_neighbors[6] = ((row+1)%16)*16 + col;            // bottom
            get_neighbors[7] = ((row+1)%16)*16 + ((col+1)%16);   // bottom-right
        end
    endfunction

    // Next state logic
    wire [255:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Get pre-computed neighbor indices
            wire [7:0][7:0] neighbors = get_neighbors(i[7:0]);
            
            // Count live neighbors using balanced adder tree
            wire [1:0] sum_stage1_0 = q[neighbors[0]] + q[neighbors[1]];
            wire [1:0] sum_stage1_1 = q[neighbors[2]] + q[neighbors[3]];
            wire [1:0] sum_stage1_2 = q[neighbors[4]] + q[neighbors[5]];
            wire [1:0] sum_stage1_3 = q[neighbors[6]] + q[neighbors[7]];
            
            wire [2:0] sum_stage2_0 = sum_stage1_0 + sum_stage1_1;
            wire [2:0] sum_stage2_1 = sum_stage1_2 + sum_stage1_3;
            
            wire [3:0] neighbor_count = sum_stage2_0 + sum_stage2_1;
            
            // Apply game rules using case statement
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              (neighbor_count == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule