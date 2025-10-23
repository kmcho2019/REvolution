module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam CELL_CNT = 256;

    // Registers to hold current and next grid states
    reg [255:0] current_grid;
    reg [255:0] next_grid;

    // Processing index: which cell we are updating in the current cycle
    reg [7:0] proc_idx;

    // Extract row and column from proc_idx
    wire [3:0] row = proc_idx[7:4];
    wire [3:0] col = proc_idx[3:0];

    // Function to wrap indices modulo 16 using 4-bit mask
    function [3:0] wrap16;
        input integer val;
        begin
            wrap16 = val[3:0];
        end
    endfunction

    // Compute the number of live neighbors for given row and col
    function [3:0] count_neighbors;
        input [255:0] grid;
        input [3:0] r;
        input [3:0] c;
        integer dr, dc;
        reg [3:0] rr, cc;
        reg [3:0] cnt;
        begin
            cnt = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        rr = wrap16(r + dr);
                        cc = wrap16(c + dc);
                        cnt = cnt + grid[rr*SIZE + cc];
                    end
                end
            end
            count_neighbors = cnt;
        end
    endfunction

    // Sequential update: one cell per clock
    always @(posedge clk) begin
        if (load) begin
            // Load initial state and reset index
            current_grid <= data;
            next_grid <= 256'd0;
            proc_idx <= 8'd0;
            q <= data; // update output immediately on load
        end else begin
            // Process one cell per cycle
            // Calculate neighbor count and update next_grid cell accordingly
            reg current_cell;
            reg [3:0] ncount;
            current_cell = current_grid[proc_idx];
            ncount = count_neighbors(current_grid, row, col);

            // Apply rules
            if (ncount == 4'd2)
                next_grid[proc_idx] <= current_cell;    // same state
            else if (ncount == 4'd3)
                next_grid[proc_idx] <= 1'b1;            // alive
            else
                next_grid[proc_idx] <= 1'b0;            // dead

            // Increment index
            if (proc_idx == CELL_CNT - 1) begin
                // Finished one full update of next_grid
                proc_idx <= 8'd0;
                current_grid <= next_grid;  // commit next generation
                q <= next_grid;             // update output grid after full update
                next_grid <= 256'd0;        // clear next grid for next iteration
            end else begin
                proc_idx <= proc_idx + 1;
            end
        end
    end

endmodule