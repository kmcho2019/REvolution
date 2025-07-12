module Rule110Block #(parameter WIDTH = 16) (
    input  wire          clk,
    input  wire          load,
    input  wire [WIDTH-1:0] data,
    input  wire          left_neighbor,  // neighbor bit left of MSB (q[block*WIDTH + WIDTH])
    input  wire          right_neighbor, // neighbor bit right of LSB (q[block*WIDTH - 1])
    output reg  [WIDTH-1:0] q
);
    // Create an extended vector with neighbors for easy indexing: {left_neighbor, q, right_neighbor}
    wire [WIDTH+1:0] ext_q;
    assign ext_q = {left_neighbor, q, right_neighbor};

    wire [WIDTH-1:0] next_q;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_rule110_logic
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110 formula simplified: next = (~left & center) | (center ^ right)
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
    // Parameters for partitioning
    localparam BLOCK_WIDTH = 16;
    localparam BLOCKS = 512 / BLOCK_WIDTH; // = 32 blocks

    wire [BLOCK_WIDTH-1:0] block_q [0:BLOCKS-1];
    wire [BLOCK_WIDTH-1:0] block_data [0:BLOCKS-1];

    genvar b;
    generate
        // Partition input data into blocks
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_data_partition
            assign block_data[b] = data[b*BLOCK_WIDTH +: BLOCK_WIDTH];
        end
    endgenerate

    // Assemble entire q vector from blocks to extract neighbor bits
    wire [511:0] assembled_q;
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_assemble
            assign assembled_q[b*BLOCK_WIDTH +: BLOCK_WIDTH] = block_q[b];
        end
    endgenerate

    // Calculate neighbors for each block
    // left_neighbor: bit just left of block MSB (q[(b+1)*BLOCK_WIDTH]) or 0 if last block
    // right_neighbor: bit just right of block LSB (q[b*BLOCK_WIDTH - 1]) or 0 if first block
    wire [BLOCKS-1:0] left_neighbors;
    wire [BLOCKS-1:0] right_neighbors;

    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_neighbors_assign
            // left_neighbor
            if (b == BLOCKS - 1) begin
                assign left_neighbors[b] = 1'b0;
            end else begin
                assign left_neighbors[b] = assembled_q[(b+1)*BLOCK_WIDTH];
            end
            // right_neighbor
            if (b == 0) begin
                assign right_neighbors[b] = 1'b0;
            end else begin
                assign right_neighbors[b] = assembled_q[b*BLOCK_WIDTH - 1];
            end
        end
    endgenerate

    // Instantiate Rule110Block modules with smaller block size
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_rule110_blocks
            Rule110Block #(.WIDTH(BLOCK_WIDTH)) block_inst (
                .clk(clk),
                .load(load),
                .data(block_data[b]),
                .left_neighbor(left_neighbors[b]),
                .right_neighbor(right_neighbors[b]),
                .q(block_q[b])
            );
        end
    endgenerate

    // Assign final output q
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_assign_out
            assign q[b*BLOCK_WIDTH +: BLOCK_WIDTH] = block_q[b];
        end
    endgenerate

endmodule