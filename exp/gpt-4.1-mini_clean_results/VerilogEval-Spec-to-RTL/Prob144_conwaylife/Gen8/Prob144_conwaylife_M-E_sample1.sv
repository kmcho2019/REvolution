module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;

    // Helper functions for bitwise rotation (wrap-around) within 16-bit rows
    function automatic [SIZE-1:0] rotl1;
        input [SIZE-1:0] in;
        begin
            rotl1 = {in[SIZE-2:0], in[SIZE-1]};
        end
    endfunction

    function automatic [SIZE-1:0] rotr1;
        input [SIZE-1:0] in;
        begin
            rotr1 = {in[0], in[SIZE-1:1]};
        end
    endfunction

    // Registers holding the 3 rows required for neighbor calculations:
    // prev_row: row above current row (wraps around)
    // curr_row: current row being processed
    // next_row: row below current row (wraps around)
    reg [SIZE-1:0] prev_row, curr_row, next_row;

    // Row index pointer to know which row we are currently processing (0 to 15)
    reg [3:0] row_ptr;

    // Next row pointer (mod 16)
    wire [3:0] row_minus1 = (row_ptr == 0) ? SIZE-1 : row_ptr - 1;
    wire [3:0] row_plus1  = (row_ptr == SIZE-1) ? 0 : row_ptr + 1;

    // Extract rows from q for initialization / reading neighbor rows
    wire [SIZE-1:0] q_rows [0:SIZE-1];
    genvar i;
    generate
        for (i=0; i < SIZE; i=i+1) begin : EXTRACT_ROWS
            assign q_rows[i] = q[i*SIZE +: SIZE];
        end
    endgenerate

    // Compute neighbor counts for curr_row cells by summing their 8 neighbors
    // Neighbors are bits from prev_row, curr_row, next_row, shifted left/right and center columns excluding the current cell
    wire [3:0] neighbor_count [SIZE-1:0];
    integer ci;
    generate
        for (ci = 0; ci < SIZE; ci = ci + 1) begin : NEIGHBOR_COUNT
            wire [SIZE-1:0] prev = prev_row;
            wire [SIZE-1:0] curr = curr_row;
            wire [SIZE-1:0] next = next_row;

            // Neighbors in prev_row
            wire p_l = prev[(ci == 0) ? SIZE-1 : ci - 1];
            wire p_c = prev[ci];
            wire p_r = prev[(ci == SIZE-1) ? 0 : ci + 1];

            // Neighbors in curr_row (excluding current cell ci)
            wire c_l = curr[(ci == 0) ? SIZE-1 : ci - 1];
            wire c_r = curr[(ci == SIZE-1) ? 0 : ci + 1];

            // Neighbors in next_row
            wire n_l = next[(ci == 0) ? SIZE-1 : ci - 1];
            wire n_c = next[ci];
            wire n_r = next[(ci == SIZE-1) ? 0 : ci + 1];

            // Sum neighbors
            wire [3:0] sum_neighbors = p_l + p_c + p_r + c_l + c_r + n_l + n_c + n_r;

            assign neighbor_count[ci] = sum_neighbors;
        end
    endgenerate

    // Compute next state bits for curr_row based on the rules
    wire [SIZE-1:0] next_row_state;
    generate
        for (ci = 0; ci < SIZE; ci = ci + 1) begin : NEXT_STATE
            wire curr_cell = curr_row[ci];
            wire [3:0] ncount = neighbor_count[ci];
            assign next_row_state[ci] =
                (ncount <= 1) ? 1'b0 :
                (ncount == 2) ? curr_cell :
                (ncount == 3) ? 1'b1 :
                1'b0;
        end
    endgenerate

    // On each clock, update row registers and q according to load and pipelined processing
    always @(posedge clk) begin
        if (load) begin
            // Load data input into q and initialize row registers for processing
            q <= data;
            // Start processing from row 0: load prev, curr, next rows from data
            row_ptr <= 0;
            prev_row <= data[(SIZE*(SIZE-1)) +: SIZE];    // last row wraps as prev of row 0
            curr_row <= data[0 +: SIZE];
            next_row <= data[SIZE +: SIZE];
        end else begin
            // Update q row for the current row pointer with computed next_row_state
            q[row_ptr*SIZE +: SIZE] <= next_row_state;

            // Advance row pointer
            if (row_ptr == SIZE - 1) begin
                row_ptr <= 0;
                // After processing last row, reload row registers for next generation start:
                prev_row <= next_row;
                curr_row <= q[0 +: SIZE];       // After last row processed, curr_row = row 0 (updated q)
                next_row <= q[SIZE +: SIZE];
            end else begin
                row_ptr <= row_ptr + 1;
                // Rotate rows downward for next iteration
                prev_row <= curr_row;
                curr_row <= next_row;
                next_row <= q[(row_ptr + 2) * SIZE +: SIZE];
            end
        end
    end

endmodule