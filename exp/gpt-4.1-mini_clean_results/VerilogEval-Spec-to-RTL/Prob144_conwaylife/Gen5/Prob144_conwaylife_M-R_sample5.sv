module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;
    localparam SIZE = WIDTH * HEIGHT;

    // Mask for wrapping indices modulo 16
    wire [3:0] wrap_r [0:HEIGHT-1];
    wire [3:0] wrap_c [0:WIDTH-1];

    genvar i;
    generate
        for (i = 0; i < HEIGHT; i = i + 1) begin : gen_wrap_r
            assign wrap_r[i] = i[3:0]; // trivial here, just preserve bits
        end
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_wrap_c
            assign wrap_c[i] = i[3:0];
        end
    endgenerate

    // For neighbor offset vectors
    localparam int NEIGHBORS = 8;
    // Relative neighbor coordinate offsets (r,c)
    wire signed [3:0] drow [0:NEIGHBORS-1];
    wire signed [3:0] dcol [0:NEIGHBORS-1];

    assign drow[0] = -1; assign dcol[0] = -1;
    assign drow[1] = -1; assign dcol[1] = 0;
    assign drow[2] = -1; assign dcol[2] = 1;
    assign drow[3] = 0;  assign dcol[3] = -1;
    assign drow[4] = 0;  assign dcol[4] = 1;
    assign drow[5] = 1;  assign dcol[5] = -1;
    assign drow[6] = 1;  assign dcol[6] = 0;
    assign drow[7] = 1;  assign dcol[7] = 1;

    // Function to wrap indices modulo 16 using bitwise AND
    function [3:0] wrap16;
        input integer idx;
        begin
            wrap16 = idx & 4'hF;
        end
    endfunction

    // Flatten indexing helper: index = (row << 4) + col
    function integer idx_flat;
        input integer r;
        input integer c;
        begin
            idx_flat = (r << 4) + c;
        end
    endfunction

    // Wires to hold neighbor counts per cell (0..8)
    wire [3:0] neighbor_counts [0:SIZE-1];

    genvar r, c, n;
    generate
        // For every cell, compute neighbor count by summing the 8 neighbors
        for (r = 0; r < HEIGHT; r = r + 1) begin : gen_rows
            for (c = 0; c < WIDTH; c = c + 1) begin : gen_cols
                wire [3:0] sum_neighbors;
                wire [SIZE-1:0] neighbor_bits;

                // Collect neighbor bits in a vector
                wire [7:0] nb_bits;
                for (n = 0; n < NEIGHBORS; n = n + 1) begin : gen_neighbors
                    // Wrap neighbor indices using wrap16 function
                    wire [3:0] nr = wrap16(r + drow[n]);
                    wire [3:0] nc = wrap16(c + dcol[n]);
                    assign nb_bits[n] = q[idx_flat(nr, nc)];
                end

                // Sum neighbors bits (8 bits) to 4-bit count
                assign sum_neighbors =
                    nb_bits[0] + nb_bits[1] + nb_bits[2] +
                    nb_bits[3] + nb_bits[4] + nb_bits[5] +
                    nb_bits[6] + nb_bits[7];

                assign neighbor_counts[idx_flat(r, c)] = sum_neighbors;
            end
        end
    endgenerate

    // Next state vector computed combinationally from q and neighbor_counts
    wire [SIZE-1:0] next_state_flat;

    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : gen_next_rows
            for (c = 0; c < WIDTH; c = c + 1) begin : gen_next_cols
                integer index = idx_flat(r, c);
                wire [3:0] ncount = neighbor_counts[index];
                wire curr_cell = q[index];
                wire next_bit;

                // Apply rules:
                // 0-1 neighbors -> 0
                // 2 neighbors -> same as current cell
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                assign next_bit =
                    (ncount <= 1) ? 1'b0 :
                    (ncount == 2) ? curr_cell :
                    (ncount == 3) ? 1'b1 :
                    1'b0;

                assign next_state_flat[index] = next_bit;
            end
        end
    endgenerate

    // Sequential update of q: load data if load asserted, else q <= next_state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state_flat;
        end
    end

endmodule