module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    // Grid dimensions
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // wrap_index implemented as 4-bit mask to do mod 16
    function [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0];
        end
    endfunction

    // Neighbor count per cell stored as 4 bits (max 8 neighbors)
    reg [3:0] neighbor_count [0:HEIGHT-1][0:WIDTH-1];

    // Pipeline stage registers
    // Stage 1: count neighbors -> neighbor_count
    // Stage 2: update q using neighbor_count and q

    integer r, c, dr, dc;
    integer nr, nc;
    reg current_cell;
    reg [3:0] neighbors_tmp;

    always @(posedge clk) begin
        if (load) begin
            // Load initial state, reset neighbor_count to 0
            q <= data;
            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    neighbor_count[r][c] <= 4'd0;
                end
            end
        end else begin
            // Stage 1: compute neighbor counts from current q
            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    neighbors_tmp = 4'd0;
                    for (dr = -1; dr <= 1; dr = dr + 1) begin
                        for (dc = -1; dc <= 1; dc = dc + 1) begin
                            if (!(dr == 0 && dc == 0)) begin
                                nr = wrap_index(r + dr);
                                nc = wrap_index(c + dc);
                                neighbors_tmp = neighbors_tmp + q[(nr << 4) + nc];
                            end
                        end
                    end
                    neighbor_count[r][c] <= neighbors_tmp;
                end
            end

            // Stage 2: update q using stored neighbor_count and current q
            // Note: neighbor_count was from previous clock cycle; this stage updates q based on that.
            // We can perform the update on the same clock edge after neighbor_count updated,
            // so neighbor_count here corresponds to previous count (before posedge).

            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    current_cell = q[(r << 4) + c];
                    neighbors_tmp = neighbor_count[r][c];
                    if (neighbors_tmp <= 4'd1)
                        q[(r << 4) + c] <= 1'b0;
                    else if (neighbors_tmp == 4'd2)
                        q[(r << 4) + c] <= current_cell;
                    else if (neighbors_tmp == 4'd3)
                        q[(r << 4) + c] <= 1'b1;
                    else
                        q[(r << 4) + c] <= 1'b0;
                end
            end
        end
    end

endmodule