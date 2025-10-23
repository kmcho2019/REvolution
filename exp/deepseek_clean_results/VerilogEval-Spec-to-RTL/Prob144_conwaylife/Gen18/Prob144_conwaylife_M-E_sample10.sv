module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Neighbor counting registers
    reg [255:0] q_ff;
    wire [255:0] neighbor_counts;

    // Circular shift functions for wrap-around
    function [15:0] shift_left(input [15:0] row);
        shift_left = {row[14:0], row[15]};
    endfunction

    function [15:0] shift_right(input [15:0] row);
        shift_right = {row[0], row[15:1]};
    endfunction

    // Generate neighbor counts for all cells
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            // Get current and adjacent rows with wrap-around
            wire [15:0] row_prev = (i == 0) ? q_ff[255:240] : q_ff[(i-1)*16 +: 16];
            wire [15:0] row_curr = q_ff[i*16 +: 16];
            wire [15:0] row_next = (i == 15) ? q_ff[15:0] : q_ff[(i+1)*16 +: 16];

            // Calculate shifted versions for neighbor access
            wire [15:0] row_prev_left = shift_left(row_prev);
            wire [15:0] row_prev_right = shift_right(row_prev);
            wire [15:0] row_curr_left = shift_left(row_curr);
            wire [15:0] row_curr_right = shift_right(row_curr);
            wire [15:0] row_next_left = shift_left(row_next);
            wire [15:0] row_next_right = shift_right(row_next);

            // Count neighbors for each cell in this row
            for (genvar j = 0; j < 16; j = j + 1) begin : cell_gen
                // Sum neighbors from all 8 directions
                wire [3:0] count = 
                    row_prev_left[j] + row_prev[j] + row_prev_right[j] +
                    row_curr_left[j] + row_curr_right[j] +
                    row_next_left[j] + row_next[j] + row_next_right[j];

                assign neighbor_counts[i*16 + j] = count;
            end
        end
    endgenerate

    // Stage 2: Next state calculation
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_ff <= data;
        end else begin
            // Update all cells in parallel based on neighbor counts
            for (integer i = 0; i < 256; i = i + 1) begin
                case (neighbor_counts[i])
                    0, 1: q[i] <= 1'b0;       // Die from underpopulation
                    2: q[i] <= q_ff[i];       // Stay the same
                    3: q[i] <= 1'b1;          // Reproduction
                    default: q[i] <= 1'b0;    // Die from overpopulation
                endcase
            end
            q_ff <= q;  // Pipeline register for next cycle's neighbor calculation
        end
    end

endmodule