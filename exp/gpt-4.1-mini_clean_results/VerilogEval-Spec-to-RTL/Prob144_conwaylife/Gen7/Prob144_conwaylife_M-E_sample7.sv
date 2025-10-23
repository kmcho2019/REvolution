module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;
    localparam SIZE = WIDTH * HEIGHT; // 256

    reg [255:0] next_q;
    reg [7:0] cell_index; // 0 to 255, indexing current cell being processed
    reg processing;        // high when processing the next state (not loading)
    
    // Compute row and column from cell_index
    wire [3:0] r = cell_index[7:4]; // upper 4 bits
    wire [3:0] c = cell_index[3:0]; // lower 4 bits

    // Function for wrap-around index modulo 16 using masking
    function [3:0] wrap4(input integer x);
        begin
            wrap4 = x[3:0]; // modulo 16 by taking lower 4 bits
        end
    endfunction

    // Function to get cell value with wrap-around from q or next_q
    function get_cell(input [255:0] grid, input integer row, input integer col);
        integer rr, cc;
        integer idx;
        begin
            rr = wrap4(row);
            cc = wrap4(col);
            idx = rr * WIDTH + cc;
            get_cell = grid[idx];
        end
    endfunction

    integer dr, dc;
    integer neighbor_count;

    // Main sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q <= data;
            cell_index <= 0;
            processing <= 1'b0; // Start fresh
        end else begin
            if (processing == 1'b0) begin
                // Begin processing the grid state step by step
                processing <= 1'b1;
                cell_index <= 0;
            end else begin
                // Count neighbors of the current cell in q
                neighbor_count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbor_count = neighbor_count + get_cell(q, r + dr, c + dc);
                        end
                    end
                end

                // Current cell state
                if (neighbor_count <= 1) begin
                    next_q[cell_index] <= 1'b0;
                end else if (neighbor_count == 2) begin
                    next_q[cell_index] <= q[cell_index];
                end else if (neighbor_count == 3) begin
                    next_q[cell_index] <= 1'b1;
                end else begin
                    next_q[cell_index] <= 1'b0;
                end

                // Advance to next cell
                if (cell_index == SIZE - 1) begin
                    q <= next_q;  // Update state after all cells processed
                    processing <= 1'b0;
                end else begin
                    cell_index <= cell_index + 1;
                end
            end
        end
    end

endmodule