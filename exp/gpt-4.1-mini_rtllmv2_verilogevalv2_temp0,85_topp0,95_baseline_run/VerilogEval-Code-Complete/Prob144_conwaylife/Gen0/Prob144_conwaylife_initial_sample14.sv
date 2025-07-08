module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Internal 2D representation of the grid for easier neighbor computation
    reg [0:15][0:15] grid;       // current state
    reg [0:15][0:15] next_grid;  // next state

    integer r, c;

    // Convert flat vector to 2D grid
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Each row is 16 bits, with q[16*r + c]
                grid[r][c] = q[16*r + c];
            end
        end
    end

    // Count neighbors with wrap-around
    function [3:0] count_neighbors;
        input integer rr;
        input integer cc;
        integer dr, dc;
        integer nr, nc;
        integer count;
        begin
            count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = rr + dr;
                        nc = cc + dc;
                        // Wrap around toroid
                        if (nr < 0)
                            nr = 15;
                        else if (nr > 15)
                            nr = 0;
                        if (nc < 0)
                            nc = 15;
                        else if (nc > 15)
                            nc = 0;
                        if (grid[nr][nc])
                            count = count + 1;
                    end
                end
            end
            count_neighbors = count[3:0];
        end
    endfunction

    // Compute next_grid combinationally using the rules
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                case (count_neighbors(r,c))
                    2: next_grid[r][c] = grid[r][c]; // unchanged
                    3: next_grid[r][c] = 1'b1;       // becomes alive
                    default: next_grid[r][c] = 1'b0; // otherwise dead
                endcase
            end
        end
    end

    // Update q on clock edge: load input data if load is high,
    // else update to next state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Flatten next_grid to q
            for (r = 0; r < 16; r = r + 1) begin
                for (c = 0; c < 16; c = c + 1) begin
                    q[16*r + c] <= next_grid[r][c];
                end
            end
        end
    end
endmodule