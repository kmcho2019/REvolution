module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-compute neighbor indices using optimized wrap-around
    wire [7:0][3:0] neighbor_indices [0:255]; // 8 neighbors, 4-bit index each
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                // Calculate neighbor positions with optimized wrap-around
                wire [3:0] row_p = i - 1;
                wire [3:0] row_n = i + 1;
                wire [3:0] col_p = j - 1;
                wire [3:0] col_n = j + 1;
                
                assign neighbor_indices[idx][0] = {row_p[3:0], col_p[3:0]}; // NW
                assign neighbor_indices[idx][1] = {row_p[3:0], j[3:0]};    // N
                assign neighbor_indices[idx][2] = {row_p[3:0], col_n[3:0]}; // NE
                assign neighbor_indices[idx][3] = {i[3:0], col_p[3:0]};    // W
                assign neighbor_indices[idx][4] = {i[3:0], col_n[3:0]};     // E
                assign neighbor_indices[idx][5] = {row_n[3:0], col_p[3:0]}; // SW
                assign neighbor_indices[idx][6] = {row_n[3:0], j[3:0]};     // S
                assign neighbor_indices[idx][7] = {row_n[3:0], col_n[3:0]};// SE
            end
        end
    endgenerate

    // Next state logic with optimized counting
    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Stage 1: 3+3+2 neighbor count with carry-save
            wire [1:0] sum_a = q[neighbor_indices[i][0]] + q[neighbor_indices[i][1]] + q[neighbor_indices[i][2]];
            wire [1:0] sum_b = q[neighbor_indices[i][3]] + q[neighbor_indices[i][4]] + q[neighbor_indices[i][5]];
            wire [1:0] sum_c = q[neighbor_indices[i][6]] + q[neighbor_indices[i][7]];
            
            // Stage 2: Final count with carry-save optimization
            wire [2:0] temp_sum = sum_a + sum_b;
            wire [3:0] neighbor_count = temp_sum + sum_c;
            
            // Stability detection
            assign cell_stable[i] = (neighbor_count == 4'd2) & q[i];
            
            // Next state rules
            assign next_q[i] = (neighbor_count == 4'd3) ? 1'b1 :
                              (neighbor_count == 4'd2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Clock-gated state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule