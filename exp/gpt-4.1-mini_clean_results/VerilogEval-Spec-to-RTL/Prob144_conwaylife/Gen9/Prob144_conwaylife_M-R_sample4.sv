module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Represent grid as a 2D packed reg for current state
    reg [N-1:0] grid [N-1:0];
    reg [N-1:0] next_grid [N-1:0];

    integer i, j;

    // Function to wrap indices modulo N
    function automatic int wrap_idx(input int idx);
        if (idx < 0)
            wrap_idx = idx + N;
        else if (idx >= N)
            wrap_idx = idx - N;
        else
            wrap_idx = idx;
    endfunction

    // Function to compute neighbors sum for cell (r,c)
    function automatic [3:0] neighbor_sum(input int r, input int c);
        integer rr, cc;
        integer nr;
        integer nc;
        integer sum;
        begin
            sum = 0;
            for (rr = -1; rr <= 1; rr = rr + 1) begin
                for (cc = -1; cc <= 1; cc = cc + 1) begin
                    if (!(rr == 0 && cc == 0)) begin
                        nr = wrap_idx(r + rr);
                        nc = wrap_idx(c + cc);
                        sum = sum + grid[nr][nc];
                    end
                end
            end
            neighbor_sum = sum;
        end
    endfunction

    // Unpack q into grid combinationally
    always @(*) begin
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                grid[i][j] = q[i*N + j];
    end

    // Compute next_grid combinationally
    always @(*) begin
        integer ns;
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                ns = neighbor_sum(i, j);
                case (ns)
                    0,1: next_grid[i][j] = 1'b0;
                    2:    next_grid[i][j] = grid[i][j];
                    3:    next_grid[i][j] = 1'b1;
                    default: next_grid[i][j] = 1'b0;
                endcase
            end
        end
    end

    // On clock edge, either load new data or update to next state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Flatten next_grid into q
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    q[i*N + j] <= next_grid[i][j];
                end
            end
        end
    end

endmodule