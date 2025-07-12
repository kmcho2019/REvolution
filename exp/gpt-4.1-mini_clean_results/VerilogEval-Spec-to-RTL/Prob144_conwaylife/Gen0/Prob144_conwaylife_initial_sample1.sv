module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    // Internal 2D representation of current state
    reg [0:15][0:15] grid_curr;
    reg [0:15][0:15] grid_next;

    integer i, j, di, dj;
    integer ni, nj;
    integer neighbors;

    // Convert q vector to 2D grid for convenience
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                grid_curr[i][j] = q[i*16 + j];
            end
        end
    end

    // Combinational logic to calculate next state
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbors = 0;
                // Sum neighbors with wrap-around
                for (di = -1; di <= 1; di = di + 1) begin
                    for (dj = -1; dj <= 1; dj = dj + 1) begin
                        if (!(di == 0 && dj == 0)) begin
                            // wrap row and col indexes
                            ni = (i + di + 16) % 16;
                            nj = (j + dj + 16) % 16;
                            neighbors = neighbors + grid_curr[ni][nj];
                        end
                    end
                end

                // Apply rules
                case (neighbors)
                    0,1: grid_next[i][j] = 1'b0;
                    2:   grid_next[i][j] = grid_curr[i][j];
                    3:   grid_next[i][j] = 1'b1;
                    default: grid_next[i][j] = 1'b0; // 4 or more neighbors
                endcase
            end
        end
    end

    // Sequential logic: update state on clk edge or load data
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Flatten grid_next to q
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    q[i*16 + j] <= grid_next[i][j];
                end
            end
        end
    end

endmodule