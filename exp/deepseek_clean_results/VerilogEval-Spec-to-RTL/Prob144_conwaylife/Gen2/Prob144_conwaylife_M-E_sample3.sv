module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Neighbor position mapping (ROM-like)
    wire [7:0][7:0] neighbor_pos [0:255]; // 256 cells x 8 neighbors x 8-bit position
    
    // Generate neighbor mapping (toroidal)
    genvar i, j, n;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                localparam idx = i*16 + j;
                // Generate all 8 neighbor positions for each cell
                for (n = 0; n < 8; n = n + 1) begin : neighbors
                    localparam dx = (n % 3) - 1;
                    localparam dy = (n / 3) - 1;
                    if (dx == 0 && dy == 0) begin // Skip self
                        assign neighbor_pos[idx][n] = 8'hFF; // Invalid marker
                    end else begin
                        // Calculate wrapped coordinates
                        localparam nx = (i + dx + 16) % 16;
                        localparam ny = (j + dy + 16) % 16;
                        assign neighbor_pos[idx][n] = nx * 16 + ny;
                    end
                end
            end
        end
    endgenerate

    // Stage 2: Neighbor counting
    wire [3:0] neighbor_count [0:255]; // 4 bits per cell (max 8 neighbors)
    
    generate
        for (i = 0; i < 256; i = i + 1) begin : count
            wire [7:0] sum;
            assign sum = 
                (neighbor_pos[i][0] != 8'hFF ? q[neighbor_pos[i][0]] : 0) +
                (neighbor_pos[i][1] != 8'hFF ? q[neighbor_pos[i][1]] : 0) +
                (neighbor_pos[i][2] != 8'hFF ? q[neighbor_pos[i][2]] : 0) +
                (neighbor_pos[i][3] != 8'hFF ? q[neighbor_pos[i][3]] : 0) +
                (neighbor_pos[i][4] != 8'hFF ? q[neighbor_pos[i][4]] : 0) +
                (neighbor_pos[i][5] != 8'hFF ? q[neighbor_pos[i][5]] : 0) +
                (neighbor_pos[i][6] != 8'hFF ? q[neighbor_pos[i][6]] : 0) +
                (neighbor_pos[i][7] != 8'hFF ? q[neighbor_pos[i][7]] : 0);
            
            assign neighbor_count[i] = sum[3:0];
        end
    endgenerate

    // Stage 3: Next state calculation
    wire [255:0] next_q;
    
    generate
        for (i = 0; i < 256; i = i + 1) begin : rules
            assign next_q[i] = 
                (neighbor_count[i] == 3) ? 1'b1 :
                (neighbor_count[i] == 2) ? q[i] :
                1'b0;
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule