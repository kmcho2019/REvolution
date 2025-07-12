module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    // Represent the 16x16 grid as 16 rows of 16-bit vectors
    reg [SIZE-1:0] rows [0:SIZE-1]; // rows[0] = row0, ... rows[15] = row15

    // Helper function to rotate left with wrap
    function [SIZE-1:0] rotl1;
        input [SIZE-1:0] in;
        begin
            rotl1 = {in[SIZE-2:0], in[SIZE-1]};
        end
    endfunction

    // Helper function to rotate right with wrap
    function [SIZE-1:0] rotr1;
        input [SIZE-1:0] in;
        begin
            rotr1 = {in[0], in[SIZE-1:1]};
        end
    endfunction

    integer r;
    wire [SIZE-1:0] next_rows [0:SIZE-1];
    // Compute neighbors and next state per row
    // For row i, neighbors come from rows: (i-1)%16, i, (i+1)%16
    // For each of these rows, neighbors are left-shifted, original, and right-shifted versions
    // Sum all eight neighbors accordingly

    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : gen_rows
            // Calculate wrapped row indices
            localparam integer r_up   = (i == 0) ? SIZE - 1 : i - 1;
            localparam integer r_down = (i == SIZE - 1) ? 0 : i + 1;

            // Get neighbor rows
            wire [SIZE-1:0] up    = rows[r_up];
            wire [SIZE-1:0] mid   = rows[i];
            wire [SIZE-1:0] down  = rows[r_down];

            // Shifted versions for neighbors with toroidal wrap
            wire [SIZE-1:0] up_left    = rotl1(up);
            wire [SIZE-1:0] up_right   = rotr1(up);
            wire [SIZE-1:0] mid_left   = rotl1(mid);
            wire [SIZE-1:0] mid_right  = rotr1(mid);
            wire [SIZE-1:0] down_left  = rotl1(down);
            wire [SIZE-1:0] down_right = rotr1(down);

            // Sum neighbors as bits: total neighbors per cell (0-8)
            // We'll sum the 8 neighbor bits vector-wise.

            // First level sums: sum each pair as 2-bit values vector-wise
            wire [SIZE-1:0] n0 = up_left;
            wire [SIZE-1:0] n1 = up;
            wire [SIZE-1:0] n2 = up_right;
            wire [SIZE-1:0] n3 = mid_left;
            wire [SIZE-1:0] n4 = mid_right;
            wire [SIZE-1:0] n5 = down_left;
            wire [SIZE-1:0] n6 = down;
            wire [SIZE-1:0] n7 = down_right;

            // Sum bits by using vector arithmetic to count bits per position:
            // Add all 8 neighbor bits per position.
            // Use 4-bit vectors to store neighbor counts.

            // To add bits, we sum the bits using integers per bit position:
            // But Verilog does not have built-in vectorized popcount; do multi-level sum.

            // Convert bits to integers to sum per bit position
            // Sum = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7 (bitwise addition per bit position)
            // Implemented by summing all vectors directly as unsigned integers.

            wire [SIZE-1:0] neighbor_sum1 = n0 ^ n1 ^ n2 ^ n3 ^ n4 ^ n5 ^ n6 ^ n7; // XOR sum
            wire [SIZE-1:0] neighbor_sum2 = (n0 & n1) | (n2 & n3) | (n4 & n5) | (n6 & n7);
            // But XOR and AND don't directly give counts, so better to sum using integers.

            // Alternative: sum bits by integer addition per bit index:
            // Create an integer array and sum bits at each position
            // Since SIZE=16, we can do this combinationally using integers.

            // We'll sum bits per position:
            wire [3:0] neighbor_count [SIZE-1:0];

            genvar bit_idx;
            generate
                for (bit_idx = 0; bit_idx < SIZE; bit_idx = bit_idx +1) begin : bit_sum
                    // Sum 8 bits from neighbors at bit position bit_idx
                    wire [7:0] bits_to_sum = {n7[bit_idx], n6[bit_idx], n5[bit_idx], n4[bit_idx], n3[bit_idx], n2[bit_idx], n1[bit_idx], n0[bit_idx]};
                    wire [3:0] sum_bits;
                    assign sum_bits = bits_to_sum[0] + bits_to_sum[1] + bits_to_sum[2] + bits_to_sum[3] +
                                      bits_to_sum[4] + bits_to_sum[5] + bits_to_sum[6] + bits_to_sum[7];
                    assign neighbor_count[bit_idx] = sum_bits;
                end
            endgenerate

            // Current state bits for this row:
            wire [SIZE-1:0] cur = mid;

            // Apply rules per bit (cell) of this row:
            // Rule:
            // neighbors == 3 -> cell = 1
            // neighbors == 2 -> cell = same as before
            // else -> 0
            reg [SIZE-1:0] next_row_reg;
            integer idx;
            always @(*) begin
                for (idx = 0; idx < SIZE; idx = idx + 1) begin
                    case (neighbor_count[idx])
                        4'd3: next_row_reg[idx] = 1'b1;
                        4'd2: next_row_reg[idx] = cur[idx];
                        default: next_row_reg[idx] = 1'b0;
                    endcase
                end
            end

            assign next_rows[i] = next_row_reg;
        end
    endgenerate

    // Load data into rows on load, else update rows on clk
    always @(posedge clk) begin
        if (load) begin
            for (r = 0; r < SIZE; r = r + 1) begin
                rows[r] <= data[r*SIZE +: SIZE];
            end
        end else begin
            for (r = 0; r < SIZE; r = r + 1) begin
                rows[r] <= next_rows[r];
            end
        end
    end

    // Flatten rows back to output q
    always @(*) begin
        for (r = 0; r < SIZE; r = r + 1) begin
            q[r*SIZE +: SIZE] = rows[r];
        end
    end

endmodule