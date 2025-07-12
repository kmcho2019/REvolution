module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c;
    reg [15:0] current [15:0]; // 16 rows of 16 bits (q stored as row vectors)
    reg [15:0] next [15:0];

    // Function to return the state of cell at (row, col) with wrapping
    function automatic bit cell_at(input integer rr, input integer cc);
        begin
            cell_at = current[(rr+16)%16][(cc+16)%16];
        end
    endfunction

    // Compute neighbor count for cell (r,c)
    function automatic [3:0] neighbor_count(input integer rr, input integer cc);
        integer dr, dc;
        begin
            neighbor_count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        neighbor_count = neighbor_count + cell_at(rr+dr, cc+dc);
                    end
                end
            end
        end
    endfunction

    // On clock edge: load data or update state
    always @(posedge clk) begin
        if (load) begin
            // load input data into current
            for (r = 0; r < 16; r = r + 1) begin
                current[r] <= data[16*r +: 16];
            end
            q <= data;
        end else begin
            // calculate next state for each cell
            for (r = 0; r < 16; r = r + 1) begin
                for (c = 0; c < 16; c = c + 1) begin
                    // count neighbors
                    reg [3:0] n;
                    n = neighbor_count(r,c);
                    // apply rules:
                    // (1) 0-1 neighbour: 0
                    // (2) 2 neighbours: same state
                    // (3) 3 neighbours: 1
                    // (4) 4+ neighbours: 0
                    if (n <= 1) begin
                        next[r][c] = 1'b0;
                    end else if (n == 2) begin
                        next[r][c] = current[r][c];
                    end else if (n == 3) begin
                        next[r][c] = 1'b1;
                    end else begin
                        next[r][c] = 1'b0;
                    end
                end
            end
            // update current and output q
            for (r = 0; r < 16; r = r + 1) begin
                current[r] <= next[r];
                q[16*r +: 16] <= next[r];
            end
        end
    end

endmodule