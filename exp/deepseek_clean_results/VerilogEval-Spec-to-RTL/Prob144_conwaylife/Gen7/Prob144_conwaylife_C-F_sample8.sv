module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-compute constant neighbor indices using optimized wrap-around
    function [7:0][3:0] get_neighbor_indices(input [7:0] idx);
        automatic [3:0] row = idx[7:4];
        automatic [3:0] col = idx[3:0];
        automatic [3:0] row_p = row - 4'b1;
        automatic [3:0] row_n = row + 4'b1;
        automatic [3:0] col_p = col - 4'b1;
        automatic [3:0] col_n = col + 4'b1;
        
        get_neighbor_indices[0] = {row_p, col_p};  // top-left
        get_neighbor_indices[1] = {row_p, col};    // top
        get_neighbor_indices[2] = {row_p, col_n};  // top-right
        get_neighbor_indices[3] = {row, col_p};    // left
        get_neighbor_indices[4] = {row, col_n};    // right
        get_neighbor_indices[5] = {row_n, col_p};  // bottom-left
        get_neighbor_indices[6] = {row_n, col};    // bottom
        get_neighbor_indices[7] = {row_n, col_n};  // bottom-right
    endfunction

    // Generate constant neighbor indices for all cells
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : neighbor_indices
            wire [7:0][3:0] neighbors = get_neighbor_indices(i[7:0]);
        end
    endgenerate

    // Next state logic
    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Get neighbor values using pre-computed indices
            wire [7:0] neighbor_values;
            assign neighbor_values[0] = q[neighbor_indices[i].neighbors[0]];
            assign neighbor_values[1] = q[neighbor_indices[i].neighbors[1]];
            assign neighbor_values[2] = q[neighbor_indices[i].neighbors[2]];
            assign neighbor_values[3] = q[neighbor_indices[i].neighbors[3]];
            assign neighbor_values[4] = q[neighbor_indices[i].neighbors[4]];
            assign neighbor_values[5] = q[neighbor_indices[i].neighbors[5]];
            assign neighbor_values[6] = q[neighbor_indices[i].neighbors[6]];
            assign neighbor_values[7] = q[neighbor_indices[i].neighbors[7]];
            
            // Optimized 3+3+2 neighbor counting
            wire [1:0] sum_top = neighbor_values[0] + neighbor_values[1] + neighbor_values[2];
            wire [1:0] sum_mid = neighbor_values[3] + neighbor_values[4];
            wire [1:0] sum_bot = neighbor_values[5] + neighbor_values[6] + neighbor_values[7];
            wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
            
            // Stability detection
            assign cell_stable[i] = (neighbor_count == 4'd2);
            
            // Next state calculation
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                               (neighbor_count == 2) ? q[i] :
                               1'b0;
        end
    endgenerate

    // Clock-gated state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that aren't stable
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule