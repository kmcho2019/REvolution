module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer i;
    
    // Pre-calculate neighbor offsets (wrapped using modulo)
    function [3:0] prev_coord;
        input [3:0] x;
        prev_coord = (x == 0) ? 15 : (x - 1);
    endfunction
    
    function [3:0] next_coord;
        input [3:0] x;
        next_coord = (x == 15) ? 0 : (x + 1);
    endfunction

    // Calculate next state for all cells
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell
            // Calculate row and column indices
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            
            // Calculate neighbor coordinates with wrap-around
            wire [3:0] row_p = prev_coord(row);
            wire [3:0] row_n = next_coord(row);
            wire [3:0] col_p = prev_coord(col);
            wire [3:0] col_n = next_coord(col);
            
            // Calculate neighbor indices
            wire [7:0] nw_idx = {row_p, col_p};
            wire [7:0] n_idx  = {row_p, col};
            wire [7:0] ne_idx = {row_p, col_n};
            wire [7:0] w_idx  = {row,  col_p};
            wire [7:0] e_idx  = {row,  col_n};
            wire [7:0] sw_idx = {row_n, col_p};
            wire [7:0] s_idx  = {row_n, col};
            wire [7:0] se_idx = {row_n, col_n};
            
            // Get neighbor values
            wire nw = q[nw_idx];
            wire n  = q[n_idx];
            wire ne = q[ne_idx];
            wire w  = q[w_idx];
            wire e  = q[e_idx];
            wire sw = q[sw_idx];
            wire s  = q[s_idx];
            wire se = q[se_idx];
            
            // Count live neighbors
            wire [3:0] neighbor_count = nw + n + ne + w + e + sw + s + se;
            
            // Calculate next state
            assign next_q[i] = (neighbor_count == 2) ? q[i] :
                              (neighbor_count == 3) ? 1'b1 :
                              1'b0;
        end
    endgenerate
    
    // Update state
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule