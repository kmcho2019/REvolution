module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam N = 16;
    localparam CELL_COUNT = N*N;

    reg [255:0] next_q;
    reg [7:0] cell_idx; // 0..255

    // current q is stored in q reg
    // On load: q <= data, next_q <= data, cell_idx=0
    // On normal operation: process one cell per clock, update next_q[cell_idx]
    // After cell_idx == 255 processed, q <= next_q, cell_idx=0

    // Helper function: wrap index mod 16 by bitmask
    function [3:0] wrap_idx;
        input integer val;
        begin
            // val can be negative or >=16; convert to mod 16 using val+16 then & 15
            // val mod 16 = (val + 16) & 15
            wrap_idx = ((val + N) & 4'hF);
        end
    endfunction

    // Compute neighbors count for a single cell index (0..255)
    function [3:0] count_neighbors;
        input [255:0] current_state;
        input [7:0] idx;
        integer r, c, rr, cc;
        integer neighbor_idx;
        reg [3:0] sum;
        begin
            r = idx / N;
            c = idx % N;
            sum = 0;
            // sum neighbors with wrapping, skip cell itself
            for (rr = r - 1; rr <= r + 1; rr = rr + 1) begin
                for (cc = c - 1; cc <= c + 1; cc = cc + 1) begin
                    if (!(rr == r && cc == c)) begin
                        neighbor_idx = wrap_idx(rr)*N + wrap_idx(cc);
                        if (current_state[neighbor_idx])
                            sum = sum + 1;
                    end
                end
            end
            count_neighbors = sum;
        end
    endfunction

    // Next state logic for one cell based on neighbor count and current cell state
    function next_cell_state;
        input cell_state;
        input [3:0] n_count;
        begin
            if (n_count <= 1)
                next_cell_state = 1'b0;
            else if (n_count == 2)
                next_cell_state = cell_state;
            else if (n_count == 3)
                next_cell_state = 1'b1;
            else
                next_cell_state = 1'b0;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q <= data;
            cell_idx <= 0;
        end else begin
            // Compute and store next state of current cell_idx
            // Get neighbor count and current cell state
            // Update next_q[cell_idx]
            // Increment cell_idx and when done, transfer next_q to q and restart

            // Compute neighbors for current cell
            // We use q as current state for reading
            reg [3:0] n_count;
            reg curr_cell_state;
            curr_cell_state = q[cell_idx];
            n_count = count_neighbors(q, cell_idx);
            next_q[cell_idx] <= next_cell_state(curr_cell_state, n_count);

            if (cell_idx == CELL_COUNT - 1) begin
                q <= next_q;
                cell_idx <= 0;
            end else begin
                cell_idx <= cell_idx + 1;
            end
        end
    end

endmodule