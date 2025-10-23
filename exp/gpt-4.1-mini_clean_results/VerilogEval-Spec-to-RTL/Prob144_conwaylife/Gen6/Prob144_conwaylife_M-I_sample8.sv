module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters
    localparam SIZE = 16;
    localparam MASK = 4'hF; // For modulo 16 wrap-around

    // Internal storage of grid as array of rows (16 bits per row)
    reg [SIZE-1:0] grid_rows [0:SIZE-1];
    reg [SIZE-1:0] next_grid_rows [0:SIZE-1];

    // For neighbor calculation: relative offsets (-1, 0, +1) in 4-bit arithmetic (wrap with mask)
    wire [3:0] row_offsets [0:2];
    wire [3:0] col_offsets [0:2];
    assign row_offsets[0] = 4'hF; // -1 mod 16
    assign row_offsets[1] = 4'h0; //  0
    assign row_offsets[2] = 4'h1; // +1

    integer r, c, ro, co;

    // Wires to hold neighbor bits for one cell
    reg [8:0] neighbors_bits; // 9 bits including cell itself for easy handling

    // Function to count ones in a 9-bit vector efficiently (neighbors + cell)
    // We'll exclude center cell manually from sum
    function [3:0] popcount8;
        input [7:0] bits;
        integer i;
        begin
            popcount8 = 0;
            for (i=0; i<8; i=i+1) begin
                popcount8 = popcount8 + bits[i];
            end
        end
    endfunction

    // Extract q into grid_rows synchronously at load
    always @(posedge clk) begin
        if (load) begin
            // Load 16 rows, each 16 bits
            for (r = 0; r < SIZE; r = r +1) begin
                grid_rows[r] <= data[r*SIZE +: SIZE];
            end
        end else begin
            // Update with next state
            for (r = 0; r < SIZE; r = r +1) begin
                grid_rows[r] <= next_grid_rows[r];
            end
        end
    end

    // Combinational logic to compute next_grid_rows from grid_rows
    always @* begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                // Collect 8 neighbors using toroidal wrap
                // neighbors_bits[7:0] excludes center cell
                // We'll gather bits into neighbors_bits[7:0]
                // Indexing neighbors in order for clarity:
                // offsets: ro in {0,1,2} representing -1,0,+1
                // same for co

                integer nb_idx;
                nb_idx = 0;
                // Clear neighbors_bits
                neighbors_bits = 9'b0;

                for (ro = 0; ro < 3; ro = ro + 1) begin
                    // wrapped row
                    wire [3:0] rr = (r + row_offsets[ro]) & MASK;
                    for (co = 0; co < 3; co = co + 1) begin
                        wire [3:0] cc = (c + col_offsets[co]) & MASK;
                        // skip center cell (ro=1 and co=1)
                        if (!(ro == 1 && co == 1)) begin
                            neighbors_bits[nb_idx] = grid_rows[rr][cc];
                            nb_idx = nb_idx + 1;
                        end
                    end
                end

                // Count neighbors
                // neighbors_bits[7:0] has 8 neighbor bits
                // current cell state:
                wire curr_cell = grid_rows[r][c];
                reg [3:0] nbr_cnt = popcount8(neighbors_bits[7:0]);

                // Apply rules:
                // 0-1 neighbor -> 0
                // 2 neighbors -> same as current
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                if (nbr_cnt == 4'd2)
                    next_grid_rows[r][c] = curr_cell;
                else if (nbr_cnt == 4'd3)
                    next_grid_rows[r][c] = 1'b1;
                else
                    next_grid_rows[r][c] = 1'b0;
            end
        end
    end

    // Pack grid_rows back to output q
    always @* begin
        integer rr;
        q = 256'b0;
        for (rr = 0; rr < SIZE; rr = rr + 1) begin
            q[rr*SIZE +: SIZE] = grid_rows[rr];
        end
    end

endmodule