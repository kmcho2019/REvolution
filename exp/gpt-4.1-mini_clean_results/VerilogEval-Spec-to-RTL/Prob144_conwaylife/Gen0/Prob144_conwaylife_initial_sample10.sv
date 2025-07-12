module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameters for grid size
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Convert flat index (0..255) to 2D coordinates and vice versa
    function [3:0] row_idx(input [7:0] idx);
        row_idx = idx[7:4];
    endfunction

    function [3:0] col_idx(input [7:0] idx);
        col_idx = idx[3:0];
    endfunction

    function [7:0] to_idx(input [3:0] row, input [3:0] col);
        to_idx = {row, col};
    endfunction

    // Get the state of a cell from q given row and col with wraparound
    function cell_state(input [255:0] grid, input [3:0] r, input [3:0] c);
        reg [3:0] rr, cc;
        reg [7:0] idx;
        begin
            // Wrap around using mod 16 (mask lower 4 bits)
            rr = r & 4'hF;
            cc = c & 4'hF;
            idx = to_idx(rr, cc);
            cell_state = grid[idx];
        end
    endfunction

    integer i, j, ni, nj;
    reg [255:0] next_state;
    reg [3:0] neighbors;

    always @(*) begin
        // Compute next state combinationally
        next_state = 256'b0;
        for (i = 0; i < HEIGHT; i = i + 1) begin
            for (j = 0; j < WIDTH; j = j + 1) begin
                // Count alive neighbors with toroidal wraparound
                neighbors = 0;
                for (ni = i - 1; ni <= i + 1; ni = ni + 1) begin
                    for (nj = j - 1; nj <= j + 1; nj = nj + 1) begin
                        if (!(ni == i && nj == j)) begin
                            neighbors = neighbors + cell_state(q, ni[3:0], nj[3:0]);
                        end
                    end
                end
                // Get current cell state
                if (load) begin
                    // Load overrides next state (no need to compute in that case)
                    next_state[to_idx(i[3:0], j[3:0])] = data[to_idx(i[3:0], j[3:0])];
                end else begin
                    case (neighbors)
                        2: next_state[to_idx(i[3:0], j[3:0])] = q[to_idx(i[3:0], j[3:0])]; // stays the same
                        3: next_state[to_idx(i[3:0], j[3:0])] = 1'b1; // becomes alive
                        default: next_state[to_idx(i[3:0], j[3:0])] = 1'b0; // dies
                    endcase
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule