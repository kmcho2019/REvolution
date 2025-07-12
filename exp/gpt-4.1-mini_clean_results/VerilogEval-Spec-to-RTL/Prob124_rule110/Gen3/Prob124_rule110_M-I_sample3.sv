module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline stage 1: current state q
    // Pipeline stage 2: next state computed combinationally in blocks

    // Block size chosen as 8 for manageable combinational logic and simpler neighbor handling
    localparam BLOCK_SIZE = 8;
    localparam NUM_BLOCKS = 512 / BLOCK_SIZE;

    // Pipeline register to hold intermediate next states per block
    reg [BLOCK_SIZE-1:0] next_q_blocks [0:NUM_BLOCKS-1];

    // Next_q full bus assembled from blocks after pipeline stage 1
    wire [511:0] next_q;

    // Function: Rule110 as 3-bit input -> 1-bit output
    // Input bits: {left, center, right} as in the problem statement
    function automatic bit rule110_lut(input [2:0] triplet);
        case(triplet)
            3'b111: rule110_lut = 1'b0;
            3'b110: rule110_lut = 1'b1;
            3'b101: rule110_lut = 1'b1;
            3'b100: rule110_lut = 1'b0;
            3'b011: rule110_lut = 1'b1;
            3'b010: rule110_lut = 1'b1;
            3'b001: rule110_lut = 1'b1;
            3'b000: rule110_lut = 1'b0;
            default: rule110_lut = 1'b0; // Should not occur
        endcase
    endfunction

    // Generate block combinational computation per block, producing next state bits
    genvar b, i;
    generate
        for (b = 0; b < NUM_BLOCKS; b = b + 1) begin : block_compute
            wire [BLOCK_SIZE-1:0] block_curr;
            // Extract current block bits from q register (stage 1)
            assign block_curr = q[b*BLOCK_SIZE +: BLOCK_SIZE];

            // For each cell in block, compute next state using neighbors (considering boundaries)
            // Since neighbors cross block boundaries, we fetch neighbor bits carefully
            // For left neighbor of first cell in block: q[b*BLOCK_SIZE + 1] or q[(b+1)*BLOCK_SIZE] if within range
            // For right neighbor of last cell in block: q[b*BLOCK_SIZE - 1] or q[(b-1)*BLOCK_SIZE + BLOCK_SIZE - 1]
            // At array boundaries, neighbors outside are zero.

            wire [BLOCK_SIZE+1:0] neighbors_extended;

            // Build extended neighbor vector for block cells: [left_neighbor_cell_0, block_curr[BLOCK_SIZE-1:0], right_neighbor_cell_last]
            // Left neighbor of cell i is q[i+1], right neighbor is q[i-1] per problem description.

            // For the block's extended neighbors, define neighbors_extended as:
            // neighbors_extended[BLOCK_SIZE] = left neighbor of cell 0 in block
            // neighbors_extended[BLOCK_SIZE-1:1] = block_curr[BLOCK_SIZE-1:0]
            // neighbors_extended[0] = right neighbor of last cell in block

            // Actually, to compute triplet for cell i:
            // left = neighbors_extended[i+2]
            // center = neighbors_extended[i+1]
            // right = neighbors_extended[i]

            // So size is BLOCK_SIZE+2 = 10 bits here

            reg [BLOCK_SIZE+1:0] n_ext;

            always @(*) begin
                // Set neighbors_extended bits
                // For left neighbor of cell 0 in block (index = BLOCK_SIZE), which corresponds to q[b*BLOCK_SIZE + 1]
                if (b*BLOCK_SIZE + BLOCK_SIZE < 512)
                    n_ext[BLOCK_SIZE+1] = q[b*BLOCK_SIZE + BLOCK_SIZE]; // q[i+1] for i=last cell in block? Actually for cell0 left neighbor = q[i+1]
                else
                    n_ext[BLOCK_SIZE+1] = 1'b0;

                // Middle bits are block current bits
                n_ext[BLOCK_SIZE:1] = block_curr;

                // Right neighbor of last cell (i=0) in block = q[i-1]
                if (b*BLOCK_SIZE == 0)
                    n_ext[0] = 1'b0; // left boundary neighbor is zero
                else
                    n_ext[0] = q[b*BLOCK_SIZE - 1];
            end

            // Assign next state bits for each cell
            for (i = 0; i < BLOCK_SIZE; i = i + 1) begin : cell_loop
                wire left = n_ext[i+2];
                wire center = n_ext[i+1];
                wire right = n_ext[i];
                assign next_q_blocks[b][i] = rule110_lut({left, center, right});
            end
        end
    endgenerate

    // Assemble next_q from blocks for output after pipeline stage 1
    generate
        for (b = 0; b < NUM_BLOCKS; b = b + 1) begin : assemble_next_q
            assign next_q[b*BLOCK_SIZE +: BLOCK_SIZE] = next_q_blocks[b];
        end
    endgenerate

    // Sequential logic: On posedge clk:
    // If load high, load data into q directly
    // Else, update q with next_q from pipeline stage 1 (which was combinationally computed from q)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule