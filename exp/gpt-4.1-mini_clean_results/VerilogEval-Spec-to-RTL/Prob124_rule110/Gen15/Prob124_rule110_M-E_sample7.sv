module Rule110Block32 (
    input  wire [33:0] ext_cells,  // 32 cells + 2 boundary bits (left and right)
    output wire [31:0] next_cells
);
    // ext_cells bits: [33] left boundary bit for cell 31, [32:1] cells 31..0, [0] right boundary bit for cell 0
    // For cell i in [0..31], neighborhood is ext_cells[i+2] (left), ext_cells[i+1] (center), ext_cells[i] (right)

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : cell_logic
            wire left   = ext_cells[i + 2];
            wire center = ext_cells[i + 1];
            wire right  = ext_cells[i];
            // Rule 110: next = (~left & center) | (center ^ right)
            assign next_cells[i] = (~left & center) | (center ^ right);
        end
    endgenerate
endmodule


module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Divide the 512-bit array into 16 blocks of 32 cells
    localparam NUM_BLOCKS = 16;
    localparam BLOCK_SIZE = 32;

    wire [31:0] next_blocks [NUM_BLOCKS-1:0];

    genvar b;
    generate
        for (b = 0; b < NUM_BLOCKS; b = b + 1) begin : blocks
            // Calculate extended neighborhood for block b:
            // We need 2 extra bits: one on left and one on right side for boundary.
            // For block 0, left boundary bit = 0
            // For block NUM_BLOCKS-1, right boundary bit = 0
            // For internal blocks, boundary bits come from q.

            wire left_boundary_bit;
            wire right_boundary_bit;

            if (b == 0) begin
                assign left_boundary_bit = 1'b0; // left boundary is zero
            end else begin
                assign left_boundary_bit = q[b*BLOCK_SIZE - 1]; // last cell of previous block
            end

            if (b == NUM_BLOCKS - 1) begin
                assign right_boundary_bit = 1'b0; // right boundary is zero
            end else begin
                assign right_boundary_bit = q[(b+1)*BLOCK_SIZE]; // first cell of next block
            end

            // Create extended slice for block b: 34 bits = left_boundary_bit + 32 cells + right_boundary_bit
            wire [33:0] ext_slice;
            assign ext_slice = {left_boundary_bit, q[b*BLOCK_SIZE +: BLOCK_SIZE], right_boundary_bit};

            // Instantiate Rule110Block32 for this block
            Rule110Block32 block_inst (
                .ext_cells(ext_slice),
                .next_cells(next_blocks[b])
            );
        end
    endgenerate

    // Concatenate next_blocks to form next_q
    wire [511:0] next_q = {
        next_blocks[15], next_blocks[14], next_blocks[13], next_blocks[12],
        next_blocks[11], next_blocks[10], next_blocks[9],  next_blocks[8],
        next_blocks[7],  next_blocks[6],  next_blocks[5],  next_blocks[4],
        next_blocks[3],  next_blocks[2],  next_blocks[1],  next_blocks[0]
    };

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule