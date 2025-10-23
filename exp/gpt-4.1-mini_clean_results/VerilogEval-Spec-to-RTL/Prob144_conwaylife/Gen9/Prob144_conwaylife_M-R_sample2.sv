module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Use packed 2D arrays for easier indexing
    // Current state register as 2D packed array: rows then cols
    reg [N-1:0] grid_reg [0:N-1];
    integer i;

    // Unpack input data into 2D array on load
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < N; i = i + 1) begin
                grid_reg[i] <= data[(i+1)*N-1 -: N];
            end
        end else begin
            grid_reg <= grid_reg_next;
        end
    end

    // Output concatenation from 2D array
    always @(*) begin
        for (i = 0; i < N; i = i +1) begin
            q[(i+1)*N-1 -: N] = grid_reg[i];
        end
    end

    // Helper function for wrapping indices modulo N
    function automatic int wrap_idx(input int idx);
        if (idx < 0)
            wrap_idx = idx + N;
        else if (idx >= N)
            wrap_idx = idx - N;
        else
            wrap_idx = idx;
    endfunction

    // Combinational next state grid
    reg [N-1:0] grid_reg_next [0:N-1];

    integer r, c;
    always @(*) begin
        // For each cell
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // Sum the 8 neighbors
                int neighbors_sum = 0;
                neighbors_sum += grid_reg[wrap_idx(r-1)][wrap_idx(c-1)];
                neighbors_sum += grid_reg[wrap_idx(r-1)][wrap_idx(c)];
                neighbors_sum += grid_reg[wrap_idx(r-1)][wrap_idx(c+1)];
                neighbors_sum += grid_reg[wrap_idx(r)][wrap_idx(c-1)];
                neighbors_sum += grid_reg[wrap_idx(r)][wrap_idx(c+1)];
                neighbors_sum += grid_reg[wrap_idx(r+1)][wrap_idx(c-1)];
                neighbors_sum += grid_reg[wrap_idx(r+1)][wrap_idx(c)];
                neighbors_sum += grid_reg[wrap_idx(r+1)][wrap_idx(c+1)];

                // Apply rules:
                // 0-1 neighbor -> 0
                // 2 neighbors -> no change
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                if (neighbors_sum <= 1)
                    grid_reg_next[r][c] = 1'b0;
                else if (neighbors_sum == 2)
                    grid_reg_next[r][c] = grid_reg[r][c];
                else if (neighbors_sum == 3)
                    grid_reg_next[r][c] = 1'b1;
                else
                    grid_reg_next[r][c] = 1'b0;
            end
        end
    end

endmodule