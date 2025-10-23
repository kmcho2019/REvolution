module Rule110Block32 (
    input  wire         clk,
    input  wire         load,
    input  wire [31:0]  data,           // load data for this block
    input  wire         left_neighbor,  // bit to the left of MSB (pad zero if no neighbor)
    input  wire         right_neighbor, // bit to the right of LSB (pad zero if no neighbor)
    output reg  [31:0]  q               // current state of this 32-bit block
);
    // Construct 34-bit vector: {left_neighbor, q[31:0], right_neighbor}
    wire [33:0] ext_q = {left_neighbor, q, right_neighbor};

    wire [31:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_rule110_logic_32
            wire left   = ext_q[i+2]; // left neighbor of cell i
            wire center = ext_q[i+1]; // cell i itself
            wire right  = ext_q[i];   // right neighbor of cell i
            // Rule 110: next = (~left & center) | (center ^ right)
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

    localparam BLOCKS = 16;
    // Array to hold current state for each block
    reg [31:0] block_q [0:BLOCKS-1];
    // Load data slices
    wire [31:0] block_data [0:BLOCKS-1];

    genvar b;
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_data_partition
            assign block_data[b] = data[b*32 +: 32];
        end
    endgenerate

    // Wires for block next states
    wire [31:0] block_next_q [0:BLOCKS-1];

    // Wires for neighbor bits feeding each block (boundary bits)
    // For block b:
    // left_neighbor = MSB of block (b+1) if exists, else 0
    // right_neighbor = LSB of block (b-1) if exists, else 0
    wire [BLOCKS-1:0] left_neighbors;
    wire [BLOCKS-1:0] right_neighbors;

    // Assign neighbor bits based on block_q registers
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_neighbors_assign
            // Left neighbor (bit just left of MSB of block b)
            if (b < BLOCKS-1)
                assign left_neighbors[b] = block_q[b+1][31];
            else
                assign left_neighbors[b] = 1'b0;

            // Right neighbor (bit just right of LSB of block b)
            if (b > 0)
                assign right_neighbors[b] = block_q[b-1][0];
            else
                assign right_neighbors[b] = 1'b0;
        end
    endgenerate

    // Instantiate Rule110Block32 blocks
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_rule110_blocks
            Rule110Block32 blk (
                .clk(clk),
                .load(load),
                .data(block_data[b]),
                .left_neighbor(left_neighbors[b]),
                .right_neighbor(right_neighbors[b]),
                .q(block_next_q[b])
            );
        end
    endgenerate

    // Register block_q: update on clock, load or next state
    integer i;
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < BLOCKS; i = i + 1)
                block_q[i] <= block_data[i];
        end else begin
            for (i = 0; i < BLOCKS; i = i + 1)
                block_q[i] <= block_next_q[i];
        end
    end

    // Concatenate blocks to form output q
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_assign
            assign q[b*32 +: 32] = block_q[b];
        end
    endgenerate

endmodule