module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam TOTAL_CELLS = SIZE*SIZE;

    reg [7:0] cell_idx;           // Current cell index [0..255]
    reg [255:0] next_q;           // Accumulates next state during 256 cycles
    reg updating;                 // Flag: currently updating next_q

    // Function: modular wrap for 4-bit coordinate (0 to 15)
    function [3:0] wrap16;
        input integer val;
        begin
            if (val < 0)
                wrap16 = val + SIZE;
            else if (val >= SIZE)
                wrap16 = val - SIZE;
            else
                wrap16 = val[3:0];
        end
    endfunction

    // Convert 1D index to row
    function [3:0] idx_to_row;
        input [7:0] idx;
        begin
            idx_to_row = idx[7:4];  // Upper 4 bits
        end
    endfunction

    // Convert 1D index to column
    function [3:0] idx_to_col;
        input [7:0] idx;
        begin
            idx_to_col = idx[3:0];  // Lower 4 bits
        end
    endfunction

    // Compute neighbor count for the cell at idx
    function [3:0] neighbor_count;
        input [7:0] idx;
        integer dr, dc;
        reg [3:0] r, c;
        reg [7:0] nr_nc_idx;
        reg [3:0] count;
        begin
            r = idx_to_row(idx);
            c = idx_to_col(idx);
            count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr_nc_idx = wrap16(r+dr)*SIZE + wrap16(c+dc);
                        count = count + q[nr_nc_idx];
                    end
                end
            end
            neighbor_count = count;
        end
    endfunction

    // Compute next cell state applying the rules given
    function next_state_cell;
        input current;
        input [3:0] neighbors;
        begin
            // (1) 0-1 neighbor: 0
            // (2) 2 neighbors: same
            // (3) 3 neighbors: 1
            // (4) 4+ neighbors: 0
            if (neighbors == 2)
                next_state_cell = current;
            else if (neighbors == 3)
                next_state_cell = 1'b1;
            else
                next_state_cell = 1'b0;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load initial state
            q <= data;
            next_q <= 256'b0;
            cell_idx <= 0;
            updating <= 1'b1; // start update on next cycle
        end else if (updating) begin
            // Calculate next state for the current cell
            // Store in next_q; after 256 cycles swap to q
            reg current_bit;
            reg [3:0] neighbors;
            current_bit = q[cell_idx];
            neighbors = neighbor_count(cell_idx);
            next_q[cell_idx] <= next_state_cell(current_bit, neighbors);

            if (cell_idx == TOTAL_CELLS - 1) begin
                // Finished entire grid update
                q <= next_q;       // commit next state to q
                cell_idx <= 0;
                next_q <= 256'b0;  // clear accumulator for next generation
            end else begin
                cell_idx <= cell_idx + 1;
            end
        end
    end

endmodule