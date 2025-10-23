module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Rule 110 lookup table encoded as a function:
    // Input: {left, center, right} as 3 bits [2:0]
    // Output: next state bit
    // Truth table bits (LSB is pattern 000):
    // Patterns: 111 110 101 100 011 010 001 000
    // Next:      0   1   1   0   1   1   1   0
    // Corresponds to binary: 01101110 = 0x6E
    function automatic bit rule110_lut(input [2:0] nbr);
        // nbr is 3-bit neighborhood {left, center, right}
        begin
            case (nbr)
                3'b111: rule110_lut = 1'b0;
                3'b110: rule110_lut = 1'b1;
                3'b101: rule110_lut = 1'b1;
                3'b100: rule110_lut = 1'b0;
                3'b011: rule110_lut = 1'b1;
                3'b010: rule110_lut = 1'b1;
                3'b001: rule110_lut = 1'b1;
                3'b000: rule110_lut = 1'b0;
                default: rule110_lut = 1'b0; // safety
            endcase
        end
    endfunction

    // We partition the 512-bit q into 32 blocks of 16 bits each
    // and compute next state for each block in a generate loop.
    // This allows local boundary handling within each block.
    // For each bit in a block, neighbors are fetched from q with
    // boundary conditions zero outside full range.

    wire [511:0] next_q;

    genvar block_idx, bit_idx;
    generate
        for (block_idx = 0; block_idx < 32; block_idx = block_idx + 1) begin : block_loop
            for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin : bit_loop
                // Global bit index
                localparam int idx = block_idx * 16 + bit_idx;

                // Left neighbor is q[idx+1], except for idx=511 => 0
                wire left = (idx == 511) ? 1'b0 : q[idx + 1];
                // Center is q[idx]
                wire center = q[idx];
                // Right neighbor is q[idx-1], except for idx=0 => 0
                wire right = (idx == 0) ? 1'b0 : q[idx - 1];

                assign next_q[idx] = rule110_lut({left, center, right});
            end
        end
    endgenerate

    // Sequential logic
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule