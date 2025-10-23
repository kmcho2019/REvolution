module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0][3:0] neighbor_count_ff;
    wire [255:0] cell_stable;
    
    // Pre-computed neighbor indices
    wire [255:0][7:0] neighbor_indices [0:7];
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Optimized wrap-around using bitwise operations
                wire [3:0] row_prev = {i[3:0]} - 4'b1;
                wire [3:0] row_next = {i[3:0]} + 4'b1;
                wire [3:0] col_prev = {j[3:0]} - 4'b1;
                wire [3:0] col_next = {j[3:0]} + 4'b1;
                
                // Neighbor indices (shared between adjacent cells)
                assign neighbor_indices[0][idx] = {row_prev, col_prev}; // top-left
                assign neighbor_indices[1][idx] = {row_prev, j[3:0]};   // top
                assign neighbor_indices[2][idx] = {row_prev, col_next}; // top-right
                assign neighbor_indices[3][idx] = {i[3:0], col_prev};   // left
                assign neighbor_indices[4][idx] = {i[3:0], col_next};   // right
                assign neighbor_indices[5][idx] = {row_next, col_prev}; // bottom-left
                assign neighbor_indices[6][idx] = {row_next, j[3:0]};   // bottom
                assign neighbor_indices[7][idx] = {row_next, col_next}; // bottom-right
            end
        end
    endgenerate

    // Stage 1: Calculate neighbor sums (pipelined)
    always @(posedge clk) begin
        q_ff <= load ? data : q;
        
        for (integer idx = 0; idx < 256; idx = idx + 1) begin
            // Carry-save addition for neighbor counts
            wire [1:0] sum_top = q[neighbor_indices[0][idx]] + 
                                 q[neighbor_indices[1][idx]] + 
                                 q[neighbor_indices[2][idx]];
            wire [1:0] sum_mid = q[neighbor_indices[3][idx]] + 
                                q[neighbor_indices[4][idx]];
            wire [1:0] sum_bot = q[neighbor_indices[5][idx]] + 
                                 q[neighbor_indices[6][idx]] + 
                                 q[neighbor_indices[7][idx]];
            
            neighbor_count_ff[idx] <= sum_top + sum_mid + sum_bot;
        end
    end

    // Stage 2: Calculate next state with clock gating
    wire [255:0] next_q;
    generate
        for (genvar idx = 0; idx < 256; idx = idx + 1) begin : state_gen
            assign cell_stable[idx] = (neighbor_count_ff[idx] == 2);
            assign next_q[idx] = (neighbor_count_ff[idx] == 3) ? 1'b1 :
                                (neighbor_count_ff[idx] == 2) ? q_ff[idx] :
                                1'b0;
            
            // Clock gating for stable cells
            always @(posedge clk) begin
                if (load) begin
                    q[idx] <= data[idx];
                end else if (!cell_stable[idx]) begin
                    q[idx] <= next_q[idx];
                end
            end
        end
    endgenerate

endmodule