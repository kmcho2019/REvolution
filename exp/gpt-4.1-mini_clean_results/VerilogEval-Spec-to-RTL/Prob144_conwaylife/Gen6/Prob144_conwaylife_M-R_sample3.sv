module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Directions for neighbors: 8 directions around each cell
    // Each as (dr, dc)
    // dr and dc can be -1, 0, or 1, excluding (0,0)
    // Store as two arrays to iterate in generate loops
    localparam integer NEIGHBORS = 8;
    localparam integer dr [0:7] = '{-1, -1, -1, 0, 0, 1, 1, 1};
    localparam integer dc [0:7] = '{-1, 0, 1, -1, 1, -1, 0, 1};

    // Flattened next state register as wire array, to assign before q update
    wire [255:0] next_q;

    genvar r, c, n;
    // Function to wrap indices modulo 16 using bitmask
    function [3:0] wrap16;
        input integer idx;
        begin
            wrap16 = idx & 4'hF; // mask lower 4 bits
        end
    endfunction

    // 2D to 1D index conversion: index = (r << 4) + c
    // We'll do this in generate loops

    // For each cell, compute the sum of its 8 neighbors
    // We'll declare a wire [3:0] neighbor_count for each cell (max 8)
    wire [3:0] neighbor_count [0:255];

    // To map 2D coordinates to a flat index
    function integer idx(input integer rr, input integer cc);
        begin
            idx = (rr << 4) + cc;
        end
    endfunction

    // Declare wires for q bits for ease of indexing in generate loops
    wire [0:255] q_bits;
    assign q_bits = q;

    // Generate block to compute neighbor counts for each cell
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : ROW_LOOP
            for (c = 0; c < WIDTH; c = c + 1) begin : COL_LOOP
                wire [7:0] neighbor_bits;
                for (n = 0; n < NEIGHBORS; n = n + 1) begin : NEIGH_LOOP
                    // Wrap around row and column with wrap16
                    wire [3:0] nr = wrap16(r + dr[n]);
                    wire [3:0] nc = wrap16(c + dc[n]);
                    assign neighbor_bits[n] = q_bits[idx(nr, nc)];
                end
                // Sum neighbors by adding bits
                assign neighbor_count[idx(r,c)] = neighbor_bits[0]
                    + neighbor_bits[1]
                    + neighbor_bits[2]
                    + neighbor_bits[3]
                    + neighbor_bits[4]
                    + neighbor_bits[5]
                    + neighbor_bits[6]
                    + neighbor_bits[7];
            end
        end
    endgenerate

    // Compute next_q bits according to rules:
    // neighbors <=1 -> 0
    // neighbors ==2 -> keep current cell state
    // neighbors ==3 -> 1
    // neighbors >=4 -> 0
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < WIDTH; c = c + 1) begin : NEXT_COL
                wire [3:0] neighbors = neighbor_count[idx(r,c)];
                wire current_cell = q_bits[idx(r,c)];
                wire next_bit;

                assign next_bit = (neighbors == 4'd3) ? 1'b1 :
                                  (neighbors == 4'd2) ? current_cell :
                                  1'b0;

                assign next_q[idx(r,c)] = next_bit;
            end
        end
    endgenerate

    // Sequential logic for q update with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule