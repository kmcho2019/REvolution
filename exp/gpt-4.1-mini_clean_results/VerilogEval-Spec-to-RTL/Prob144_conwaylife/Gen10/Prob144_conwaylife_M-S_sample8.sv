module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF; // for modulo 16 wrap-around

    reg [0:SIZE-1][0:SIZE-1] curr_grid;
    reg [0:SIZE-1][0:SIZE-1] next_grid;

    integer r, c;

    // Unpack q vector into 2D array for easier indexing
    always @(*) begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                curr_grid[r][c] = q[r*SIZE + c];
            end
        end
    end

    // Compute next state combinationally
    always @(*) begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                // Sum of neighbors with toroidal wrapping
                integer nr, nc;
                integer count;
                count = 0;
                for (nr = r-1; nr <= r+1; nr = nr + 1) begin
                    for (nc = c-1; nc <= c+1; nc = nc + 1) begin
                        if (!(nr == r && nc == c)) begin
                            count = count + curr_grid[nr & MASK][nc & MASK];
                        end
                    end
                end

                // Apply game rules
                case (count)
                    2: next_grid[r][c] = curr_grid[r][c];
                    3: next_grid[r][c] = 1'b1;
                    default: next_grid[r][c] = 1'b0;
                endcase
            end
        end
    end

    // Pack next_grid back to next_q vector for update
    reg [255:0] next_q;
    always @(*) begin
        next_q = 256'b0;
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                next_q[r*SIZE + c] = next_grid[r][c];
            end
        end
    end

    // Sequential logic: load or update next state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule