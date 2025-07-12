module TopModule(
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Internal memory for storing grid rows (16 rows x 16 bits)
    reg [WIDTH-1:0] grid_mem [0:HEIGHT-1];

    // Row update pointer: which row to update next
    reg [3:0] update_row;

    // Next state buffer for the row being updated
    reg [WIDTH-1:0] next_row;

    // Helper: wrap index mod 16
    function [3:0] wrap_idx;
        input integer idx;
        begin
            if (idx < 0)
                wrap_idx = idx + 16;
            else if (idx > 15)
                wrap_idx = idx - 16;
            else
                wrap_idx = idx[3:0];
        end
    endfunction

    // Compute next state for a single row given indices of prev, curr, next rows
    // Use toroidal wrap for columns by circular shifts
    // For each bit position c in 0..15:
    // sum neighbors from prev, curr, next rows at columns c-1,c,c+1 except the center cell
    // Apply the rules accordingly

    integer c;
    reg [3:0] neighbors;
    reg curr_bit;
    reg prev_row, curr_row, next_row_bits; // temporaries

    // Combinational calculation of next_row for the current update_row
    always @(*) begin
        // Get indices for previous and next rows with wrap-around
        integer prev_r = wrap_idx(update_row - 1);
        integer next_r = wrap_idx(update_row + 1);

        // Rows for neighbor calculation
        reg [WIDTH-1:0] prev_r_bits = grid_mem[prev_r];
        reg [WIDTH-1:0] curr_r_bits = grid_mem[update_row];
        reg [WIDTH-1:0] next_r_bits = grid_mem[next_r];

        // We'll compute neighbor counts and next state for each column c
        // Using circular shifts for toroidal column wrap

        next_row = 0;
        for (c = 0; c < WIDTH; c = c + 1) begin
            // For column wrapping: left = c-1, right = c+1 (mod 16)
            integer left = (c == 0) ? WIDTH - 1 : c - 1;
            integer right = (c == WIDTH-1) ? 0 : c + 1;

            // Count neighbors:
            // Sum bits at positions [left, c, right] from prev_r_bits, curr_r_bits, next_r_bits
            // But exclude the center cell (curr_r_bits[c]) itself

            neighbors = 0;
            // Prev row neighbors
            neighbors = neighbors + prev_r_bits[left] + prev_r_bits[c] + prev_r_bits[right];
            // Curr row neighbors (excluding center cell)
            neighbors = neighbors + curr_r_bits[left] + curr_r_bits[right];
            // Next row neighbors
            neighbors = neighbors + next_r_bits[left] + next_r_bits[c] + next_r_bits[right];

            // Current cell state
            curr_bit = curr_r_bits[c];

            // Apply rules:
            // 0-1 neighbor: 0
            // 2 neighbors: unchanged
            // 3 neighbors: 1
            // 4+ neighbors: 0
            if (neighbors <= 1)
                next_row[c] = 1'b0;
            else if (neighbors == 2)
                next_row[c] = curr_bit;
            else if (neighbors == 3)
                next_row[c] = 1'b1;
            else
                next_row[c] = 1'b0;
        end
    end

    integer r;
    // Load or update rows sequentially on clock edge
    always @(posedge clk) begin
        if (load) begin
            // Load entire 256-bit data into grid_mem rows
            for (r = 0; r < HEIGHT; r = r + 1) begin
                grid_mem[r] <= data[r*WIDTH +: WIDTH];
            end
            update_row <= 0;
        end else begin
            // Update one row (update_row) per clock cycle with next_row
            grid_mem[update_row] <= next_row;

            // Increment update_row modulo HEIGHT to update all rows in 16 cycles
            update_row <= (update_row == HEIGHT-1) ? 0 : update_row + 1;
        end

        // Update output q by concatenating all rows after update
        // This reflects the current grid state synchronously
        for (r = 0; r < HEIGHT; r = r + 1) begin
            q[r*WIDTH +: WIDTH] <= grid_mem[r];
        end
    end

endmodule