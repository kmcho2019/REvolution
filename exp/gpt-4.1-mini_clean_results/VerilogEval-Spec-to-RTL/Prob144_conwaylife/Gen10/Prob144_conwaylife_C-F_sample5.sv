module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF; // For bitwise modulo 16

    // Wires for next state bits
    wire next_q [0:SIZE-1][0:SIZE-1];

    genvar r, c;

    // Generate combinational logic for neighbor count and next state per cell
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : ROW
            for (c = 0; c < SIZE; c = c + 1) begin : COL
                // Compute wrapped neighbor indices using bitwise masking (mod 16)
                // Neighbors are 8 cells surrounding (r,c), excluding center cell
                // Indices:
                // rows: r-1, r, r+1 wrapped mod 16
                // cols: c-1, c, c+1 wrapped mod 16

                // Calculate wrapped neighbor coordinates
                localparam integer r_up    = (r == 0) ? MASK : r - 1;
                localparam integer r_down  = (r == MASK) ? 0 : r + 1;
                localparam integer c_left  = (c == 0) ? MASK : c - 1;
                localparam integer c_right = (c == MASK) ? 0 : c + 1;

                // Helper function to get bit index in q vector
                function integer idx;
                    input integer rr, cc;
                    begin
                        idx = rr * SIZE + cc;
                    end
                endfunction

                // Sum of neighbors (8 bits)
                wire [3:0] neighbor_count;

                assign neighbor_count = 
                    q[idx(r_up,    c_left)] +
                    q[idx(r_up,    c    )] +
                    q[idx(r_up,    c_right)] +
                    q[idx(r,       c_left)] +
                    q[idx(r,       c_right)] +
                    q[idx(r_down,  c_left)] +
                    q[idx(r_down,  c    )] +
                    q[idx(r_down,  c_right)];

                // Current cell state
                wire current_cell = q[idx(r, c)];

                // Next state logic per rules:
                // 0-1 neighbors -> 0
                // 2 neighbors -> unchanged
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                assign next_q[r][c] = (neighbor_count == 4'd3) ? 1'b1 :
                                      (neighbor_count == 4'd2) ? current_cell :
                                      1'b0;
            end
        end
    endgenerate

    // Flatten next_q 2D array into 256-bit wire vector
    wire [255:0] next_q_flat;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : FLATTEN_COL
                assign next_q_flat[r*SIZE + c] = next_q[r][c];
            end
        end
    endgenerate

    // Synchronous state update with load input
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_flat;
    end

endmodule