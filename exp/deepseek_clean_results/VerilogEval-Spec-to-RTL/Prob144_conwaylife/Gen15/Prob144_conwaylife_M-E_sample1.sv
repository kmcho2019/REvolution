module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Row buffers for neighbor sharing
    reg [15:0] prev_row, curr_row, next_row;
    reg [15:0] prev_row_buffer, next_row_buffer;

    // State update logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Initialize row buffers
            prev_row <= data[255:240];
            curr_row <= data[15:0];
            next_row <= data[31:16];
            prev_row_buffer <= data[255:240];
            next_row_buffer <= data[31:16];
        end else begin
            // Process all cells in current row in parallel
            for (integer i = 0; i < 16; i = i + 1) begin
                // Calculate neighbor indices with toroidal wrapping
                integer left = (i-1) & 15;
                integer right = (i+1) & 15;

                // Count neighbors from 3 rows
                reg [3:0] neighbor_count;
                neighbor_count = prev_row[left] + prev_row[i] + prev_row[right] +
                                 curr_row[left] + curr_row[right] +
                                 next_row[left] + next_row[i] + next_row[right];

                // Apply game rules
                case (neighbor_count)
                    3: q[i*16 +: 16] <= 16'b1 << i;
                    2: q[i*16 +: 16] <= q[i*16 +: 16] & (16'b1 << i);
                    default: q[i*16 +: 16] <= q[i*16 +: 16] & ~(16'b1 << i);
                endcase
            end

            // Update row buffers for next cycle
            prev_row <= prev_row_buffer;
            curr_row <= q[15:0];
            next_row <= next_row_buffer;
            prev_row_buffer <= q[255:240];
            next_row_buffer <= q[31:16];
        end
    end

    // Additional logic to handle row shifts
    always @(posedge clk) begin
        if (!load) begin
            // Shift row pointers circularly
            for (integer row = 0; row < 16; row = row + 1) begin
                if (row == 15) begin
                    prev_row_buffer <= q[row*16 +: 16];
                    next_row_buffer <= q[0 +: 16];
                end else if (row == 0) begin
                    prev_row_buffer <= q[15*16 +: 16];
                    next_row_buffer <= q[(row+1)*16 +: 16];
                end else begin
                    prev_row_buffer <= q[(row-1)*16 +: 16];
                    next_row_buffer <= q[(row+1)*16 +: 16];
                end
            end
        end
    end

endmodule