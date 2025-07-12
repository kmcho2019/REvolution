module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters
    localparam N = 16;
    localparam IDX_WIDTH = 4; // enough to index 0..15

    // Storage for current state: use dual-port RAM (modeled with reg array)
    reg [N-1:0] ram [0:N-1]; // 16 rows of 16 bits

    // Write enable and address for RAM update
    reg [IDX_WIDTH-1:0] row_ptr; // current row being processed 0..15
    reg processing; // high when we are processing rows (not loading)

    // Registers for 3 rows buffer to compute neighbor sums
    reg [N-1:0] row_up;
    reg [N-1:0] row_curr;
    reg [N-1:0] row_down;

    // Next row data buffer (shifting in next states for row_ptr)
    reg [N-1:0] next_row_bits;

    // Column iterator - since we calculate one cell per clock, but to maintain throughput,
    // we'll compute one full row per clock cycle combinationally.
    // So neighbor sums and next state for 16 cells per cycle, combinational logic only.
    // The FSM processes one row each clock cycle.

    integer i;
    wire [3:0] neighbors_sum [0:N-1];
    reg [N-1:0] next_row;

    // Helper function: wraps index mod N
    function [IDX_WIDTH-1:0] wrap_idx;
        input integer idx;
        begin
            if (idx < 0)
                wrap_idx = idx + N;
            else if (idx >= N)
                wrap_idx = idx - N;
            else
                wrap_idx = idx;
        end
    endfunction

    // On load signal: initialize RAM and output q
    // FSM: 
    //  State 0: Load data into RAM
    //  State 1: Process next row each clock cycle, update that row in RAM
    //  Repeat: 16 cycles per generation

    // Extract neighbors for all 16 cells in the current row_ptr:
    // Use wrapped indices for rows: up, current, down
    wire [IDX_WIDTH-1:0] row_up_idx = wrap_idx(row_ptr - 1);
    wire [IDX_WIDTH-1:0] row_down_idx = wrap_idx(row_ptr + 1);

    // Assign rows from RAM (combinational read)
    // To avoid latches, assign to wires
    wire [N-1:0] ram_row_up = ram[row_up_idx];
    wire [N-1:0] ram_row_curr = ram[row_ptr];
    wire [N-1:0] ram_row_down = ram[row_down_idx];

    // Compute neighbors_sum for each cell in the row_ptr
    // For each cell c, neighbors are 8 surrounding cells with wrap-around on columns
    genvar c;
    generate
        for (c=0; c<N; c=c+1) begin : NEIGHBOR_SUM
            wire [IDX_WIDTH-1:0] c_left = wrap_idx(c - 1);
            wire [IDX_WIDTH-1:0] c_right = wrap_idx(c + 1);

            wire sum =
                ram_row_up[c_left] + ram_row_up[c] + ram_row_up[c_right] +
                ram_row_curr[c_left] +                ram_row_curr[c_right] +
                ram_row_down[c_left] + ram_row_down[c] + ram_row_down[c_right];

            assign neighbors_sum[c] = sum;
        end
    endgenerate

    // Calculate next_row bits combinationally applying the game rules:
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            case (neighbors_sum[i])
                4'd0,4'd1: next_row[i] = 1'b0;       // 0-1 neighbors: dies
                4'd2: next_row[i] = ram_row_curr[i]; // 2 neighbors: unchanged
                4'd3: next_row[i] = 1'b1;             // 3 neighbors: alive
                default: next_row[i] = 1'b0;          // 4+ neighbors: dies
            endcase
        end
    end

    // Sequential FSM and RAM updates
    always @(posedge clk) begin
        if (load) begin
            // Load mode: initialize RAM and q from input data
            // Data layout: rows of 16 bits, row0 at bits [15:0], row1 [31:16], etc.
            for (i = 0; i < N; i = i + 1) begin
                ram[i] <= data[i*16 +: 16];
            end
            q <= data;
            row_ptr <= 0;
            processing <= 1'b1; // Start processing after load
        end else if (processing) begin
            // Update the current row with computed next_row
            ram[row_ptr] <= next_row;

            // Update output q by flattening all rows
            // We'll build q progressively by reading all RAM rows.
            // Since RAM is fully updated only after all rows processed,
            // here we update q by reading entire RAM.
            for (i = 0; i < N; i = i + 1) begin
                q[i*16 +: 16] <= ram[i];
            end

            // Advance row pointer
            if (row_ptr == N - 1) begin
                row_ptr <= 0; // wrap back to first row for next generation
                processing <= 1'b1; // continue processing next generation
            end else begin
                row_ptr <= row_ptr + 1;
            end
        end else begin
            // Idle state: hold outputs, no action
            q <= q;
        end
    end

endmodule