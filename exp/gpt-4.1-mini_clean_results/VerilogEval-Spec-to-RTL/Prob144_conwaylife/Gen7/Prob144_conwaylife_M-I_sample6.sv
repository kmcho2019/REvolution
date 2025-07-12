module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // wrap_index: modulo 16 via masking lower 4 bits
    function [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0];
        end
    endfunction

    // Registers for neighbor counts per cell (9 bits enough for 0..8 neighbors)
    reg [3:0] r_stage1;
    reg [3:0] c_stage1;
    reg [8:0] neighbor_counts [0:HEIGHT*WIDTH-1];
    reg [255:0] q_stage1;  // Store q for stage2 input

    reg [8:0] nc_pipe [0:HEIGHT*WIDTH-1];  // Stage 2 pipeline register for counts
    reg [255:0] q_pipe;                    // Stage 2 pipeline register for cell states

    integer i;

    // Stage 1: neighbor counting (one clock cycle)
    // To implement the neighbor counting pipelined, we unroll all cells,
    // but for synthesis friendly approach we implement combinational logic for neighbor counting,
    // store results in registers at posedge clk (stage 1)
    // Then in stage 2, update the q using stored counts.

    // Combinational function to get neighbor count for a cell in current q
    function [3:0] count_neighbors;
        input integer r;
        input integer c;
        integer dr, dc;
        integer nr, nc;
        reg [3:0] count;
        begin
            count = 0;
            for (dr = -1; dr <= 1; dr = dr +1) begin
                for (dc = -1; dc <= 1; dc = dc +1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = wrap_index(r + dr);
                        nc = wrap_index(c + dc);
                        count = count + q[(nr << 4) + nc];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    // Stage 1 registers updated on posedge clk
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_stage1 <= data;
            // reset neighbor counts to zero on load
            for (i = 0; i < WIDTH*HEIGHT; i = i + 1)
                neighbor_counts[i] <= 0;
        end else begin
            q_stage1 <= q;
            // Compute neighbor counts combinationally for all cells, then register
            for (i = 0; i < WIDTH*HEIGHT; i = i + 1) begin
                neighbor_counts[i] <= count_neighbors(i >> 4, i & 4'hF);
            end
            q <= q_pipe;  // stage2 output
        end
    end

    // Stage 2 combinational next state logic from counts and current cells stored at stage1
    // This combinational block uses neighbor_counts and q_stage1 to produce q_pipe (next q)
    always @(*) begin
        integer r, c;
        integer idx;
        reg [3:0] neighbors;
        reg cell;
        q_pipe = 0;
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                idx = (r << 4) + c;
                neighbors = neighbor_counts[idx];
                cell = q_stage1[idx];
                if (neighbors <= 1)
                    q_pipe[idx] = 1'b0;
                else if (neighbors == 2)
                    q_pipe[idx] = cell;
                else if (neighbors == 3)
                    q_pipe[idx] = 1'b1;
                else
                    q_pipe[idx] = 1'b0;
            end
        end
    end

endmodule