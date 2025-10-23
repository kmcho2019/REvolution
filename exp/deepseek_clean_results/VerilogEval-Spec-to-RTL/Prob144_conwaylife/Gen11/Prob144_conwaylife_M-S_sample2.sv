module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    // Grid stored as 2D array
    reg [15:0] grid [0:15];
    
    // Neighbor counting and next state calculation
    always @(posedge clk) begin
        if (load) begin
            // Load initial data
            for (integer i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            // Game logic
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    // Count live neighbors with wrap-around (mod 16)
                    integer count = 0;
                    for (integer di = -1; di <= 1; di = di + 1) begin
                        for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                            if (di == 0 && dj == 0) continue; // Skip self
                            integer ni = (i + di + 16) % 16;
                            integer nj = (j + dj + 16) % 16;
                            count = count + grid[ni][nj];
                        end
                    end
                    
                    // Apply rules
                    case (count)
                        2: grid[i][j] <= grid[i][j]; // Stay same
                        3: grid[i][j] <= 1;          // Birth/survival
                        default: grid[i][j] <= 0;     // Death
                    endcase
                end
            end
        end
    end

    // Output mapping
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : output_map
            assign q[k*16 +: 16] = grid[k];
        end
    endgenerate

endmodule