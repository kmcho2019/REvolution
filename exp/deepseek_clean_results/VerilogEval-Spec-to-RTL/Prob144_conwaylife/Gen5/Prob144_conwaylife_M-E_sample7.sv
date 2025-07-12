module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Current state register with clock gating
    reg [255:0] current_state;
    reg [255:0] next_state;
    
    // Neighbor index lookup tables (8 neighbors x 256 cells)
    reg [7:0] neighbor_idx [0:255][0:7]; // [cell][direction] -> neighbor index
    
    // Precompute all neighbor indices
    integer i, row, col;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            row = i / 16;
            col = i % 16;
            
            // Precompute all 8 neighbor indices with toroidal wrapping
            neighbor_idx[i][0] = ((row + 15) % 16) * 16 + col;        // N
            neighbor_idx[i][1] = ((row + 1) % 16) * 16 + col;         // S
            neighbor_idx[i][2] = row * 16 + ((col + 15) % 16;        // W
            neighbor_idx[i][3] = row * 16 + ((col + 1) % 16;         // E
            neighbor_idx[i][4] = ((row + 15) % 16) * 16 + ((col + 15) % 16; // NW
            neighbor_idx[i][5] = ((row + 15) % 16) * 16 + ((col + 1) % 16;  // NE
            neighbor_idx[i][6] = ((row + 1) % 16) * 16 + ((col + 15) % 16;  // SW
            neighbor_idx[i][7] = ((row + 1) % 16) * 16 + ((col + 1) % 16;   // SE
        end
    end

    // Pipelined neighbor counting
    genvar cell;
    generate
        for (cell = 0; cell < 256; cell = cell + 1) begin : cell_logic
            // Stage 1: Fetch neighbor values
            wire [7:0] neighbors;
            assign neighbors[0] = current_state[neighbor_idx[cell][0]];
            assign neighbors[1] = current_state[neighbor_idx[cell][1]];
            assign neighbors[2] = current_state[neighbor_idx[cell][2]];
            assign neighbors[3] = current_state[neighbor_idx[cell][3]];
            assign neighbors[4] = current_state[neighbor_idx[cell][4]];
            assign neighbors[5] = current_state[neighbor_idx[cell][5]];
            assign neighbors[6] = current_state[neighbor_idx[cell][6]];
            assign neighbors[7] = current_state[neighbor_idx[cell][7]];
            
            // Stage 2: First level of addition (4x 2-input adders)
            wire [1:0] sum_a = neighbors[0] + neighbors[1];
            wire [1:0] sum_b = neighbors[2] + neighbors[3];
            wire [1:0] sum_c = neighbors[4] + neighbors[5];
            wire [1:0] sum_d = neighbors[6] + neighbors[7];
            
            // Stage 3: Second level of addition (2x 2-input adders)
            wire [2:0] sum_ab = sum_a + sum_b;
            wire [2:0] sum_cd = sum_c + sum_d;
            
            // Stage 4: Final sum
            wire [3:0] neighbor_count = sum_ab + sum_cd;
            
            // Clock gating for cells with no live neighbors
            wire cell_active = |neighbors || current_state[cell];
            
            // Update rule with clock gating
            always @(posedge clk) begin
                if (load) begin
                    next_state[cell] <= data[cell];
                end else if (cell_active) begin
                    next_state[cell] <= (neighbor_count == 2) ? current_state[cell] :
                                      (neighbor_count == 3) ? 1'b1 :
                                      1'b0;
                end
            end
        end
    endgenerate

    // State update with registered output
    always @(posedge clk) begin
        current_state <= load ? data : next_state;
        q <= current_state;
    end

endmodule