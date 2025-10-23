module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Neighbor count per cell: 4 bits needed (max 8 neighbors)
    reg [3:0] neighbor_count [0:255];

    // Stage registers to pipeline neighbor counting and state update
    reg [255:0] intermediate_q;

    integer r, c, dr, dc;
    integer nr, nc;
    integer idx;
    integer neighbors;

    // Wrap indices modulo 16 using bitwise AND
    function [3:0] wrap16(input integer idx);
        begin
            wrap16 = idx & 4'hF;
        end
    endfunction

    // First pipeline stage: calculate neighbor counts for all cells
    always @(posedge clk) begin
        if (load) begin
            // On load, set q to input data and reset pipeline registers
            q <= data;
            intermediate_q <= data;
            for (idx = 0; idx < 256; idx = idx + 1)
                neighbor_count[idx] <= 0;
        end else begin
            // Compute neighbor counts based on intermediate_q from previous cycle
            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    neighbors = 0;
                    for (dr = -1; dr <= 1; dr = dr + 1) begin
                        for (dc = -1; dc <= 1; dc = dc + 1) begin
                            if (!(dr == 0 && dc == 0)) begin
                                nr = wrap16(r + dr);
                                nc = wrap16(c + dc);
                                neighbors = neighbors + intermediate_q[(nr << 4) + nc];
                            end
                        end
                    end
                    neighbor_count[(r << 4) + c] <= neighbors[3:0];
                end
            end
            intermediate_q <= q; // Save current q to intermediate for next cycle
        end
    end

    // Second pipeline stage: update cell states based on neighbor counts and q
    always @(posedge clk) begin
        if (load) begin
            // Load overrides, set output q directly
            q <= data;
        end else begin
            for (idx = 0; idx < 256; idx = idx + 1) begin
                case (neighbor_count[idx])
                    0,1: q[idx] <= 1'b0;           // 0-1 neighbors => dead
                    2:    q[idx] <= q[idx];        // 2 neighbors => unchanged
                    3:    q[idx] <= 1'b1;          // 3 neighbors => alive
                    default: q[idx] <= 1'b0;       // 4+ neighbors => dead
                endcase
            end
        end
    end

endmodule