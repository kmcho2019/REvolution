module Rule110Block32 (
    input  wire         clk,
    input  wire         load,
    input  wire [31:0]  data,          // data to load for this block
    input  wire         left_neighbor, // neighbor bit to the left of MSB (q[block*32+32])
    input  wire         right_neighbor,// neighbor bit to the right of LSB (q[block*32-1])
    output reg  [31:0]  q              // current block state
);

    wire [33:0] ext_q; 
    // Extended state with neighbor bits for easy indexing: {left_neighbor, q, right_neighbor}
    assign ext_q = {left_neighbor, q, right_neighbor};

    // Next state logic per bit
    wire [31:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_rule110_logic_32
            wire left   = ext_q[i+2]; // left neighbor bit: one index higher
            wire center = ext_q[i+1]; // current bit
            wire right  = ext_q[i];   // right neighbor bit: one index lower
            // Rule 110 next state expression:
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule


module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Partition the 512-bit state into 16 blocks of 32 bits
    localparam BLOCKS = 16;
    wire [31:0] block_q[0:BLOCKS-1];
    wire [31:0] block_data[0:BLOCKS-1];

    genvar b;
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_partition_data
            assign block_data[b] = data[b*32 +: 32];
        end
    endgenerate

    // Signals for neighbor bits feeding each block
    wire [BLOCKS-1:0] left_neighbors;
    wire [BLOCKS-1:0] right_neighbors;

    // Calculate neighbor bits for each block, boundary bits are zero
    // left_neighbors[b] = the bit just to the left of q[b]'s MSB = q[(b+1)*32]
    // right_neighbors[b] = bit just to the right of q[b]'s LSB = q[b*32 - 1]
    // For b=0 right_neighbor = 0 (no bit to the right)
    // For b=BLOCKS-1 left_neighbor = 0 (no bit to the left)

    // Intermediate wiring to collect block outputs for neighbors
    wire [511:0] assembled_q;
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_concat
            assign assembled_q[b*32 +: 32] = block_q[b];
        end
    endgenerate

    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_neighbors
            // Left neighbor bit: MSB+1 of block b: q[(b+1)*32] if b < BLOCKS-1 else 0
            if (b < BLOCKS-1) begin
                assign left_neighbors[b] = assembled_q[(b+1)*32];
            end else begin
                assign left_neighbors[b] = 1'b0;
            end
            // Right neighbor bit: LSB-1 of block b: q[b*32 - 1] if b > 0 else 0
            if (b > 0) begin
                assign right_neighbors[b] = assembled_q[b*32 - 1];
            end else begin
                assign right_neighbors[b] = 1'b0;
            end
        end
    endgenerate


    // Instantiate Rule110Block32 modules for each block
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_rule110_blocks
            Rule110Block32 block (
                .clk(clk),
                .load(load),
                .data(block_data[b]),
                .left_neighbor(left_neighbors[b]),
                .right_neighbor(right_neighbors[b]),
                .q(block_q[b])
            );
        end
    endgenerate

    // Assemble output q from all block_q
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_assign
            assign q[b*32 +: 32] = block_q[b];
        end
    endgenerate

endmodule