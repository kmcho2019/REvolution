module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Represent grid as 2D reg array for sequential updates (load & clock)
    reg grid [0:N-1][0:N-1];

    // Convert 1D vector q to 2D array grid at clock update
    integer i, j;

    // Function to perform wrapping index for toroidal addressing
    function integer wrap_index(input integer idx);
        if (idx < 0)
            wrap_index = N - 1;
        else if (idx >= N)
            wrap_index = 0;
        else
            wrap_index = idx;
    endfunction

    // Function to count alive neighbors for a given cell with wrap-around
    function [3:0] count_neighbors(input integer r, input integer c);
        integer rr, cc;
        reg [3:0] sum;
        begin
            sum = 0;
            for (rr = r - 1; rr <= r + 1; rr = rr + 1) begin
                for (cc = c - 1; cc <= c + 1; cc = cc + 1) begin
                    if (!(rr == r && cc == c)) begin
                        sum = sum + grid[wrap_index(rr)][wrap_index(cc)];
                    end
                end
            end
            count_neighbors = sum;
        end
    endfunction

    // Next state computation in a combinational block
    reg next_grid [0:N-1][0:N-1];

    always @(*) begin
        for (i = 0; i < N; i = i +1) begin
            for (j = 0; j < N; j = j +1) begin
                reg [3:0] n_count;
                n_count = count_neighbors(i, j);
                // Apply rules:
                // 0-1 neighbors => 0
                // 2 neighbors => state unchanged
                // 3 neighbors => 1
                // 4+ neighbors => 0
                if (n_count <= 1)
                    next_grid[i][j] = 1'b0;
                else if (n_count == 2)
                    next_grid[i][j] = grid[i][j];
                else if (n_count == 3)
                    next_grid[i][j] = 1'b1;
                else
                    next_grid[i][j] = 1'b0;
            end
        end
    end

    // On clock edge: load or update state
    always @(posedge clk) begin
        if (load) begin
            // Load data vector into grid 2D reg
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    grid[i][j] <= data[i*16 + j];
                end
            end
        end else begin
            // Update grid to next state
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    grid[i][j] <= next_grid[i][j];
                end
            end
        end
    end

    // Flatten 2D grid into 1D output vector q
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                q[i*16 + j] = grid[i][j];
            end
        end
    end

endmodule