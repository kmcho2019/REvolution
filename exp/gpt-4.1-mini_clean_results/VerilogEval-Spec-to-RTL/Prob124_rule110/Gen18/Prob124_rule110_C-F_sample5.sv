module Rule110Block32 (
    input  wire         clk,
    input  wire         load,
    input  wire [31:0]  data,           // Load data for this block
    input  wire         left_neighbor,  // Registered left neighbor bit of MSB+1 cell
    input  wire         right_neighbor, // Registered right neighbor bit of LSB-1 cell
    output reg  [31:0]  q               // Current state of the 32 cells in block
);

    // Extended vector with left and right neighbors for combinational indexing:
    // bits: [33] = left_neighbor, [32:1] = q[31:0], [0] = right_neighbor
    wire [33:0] ext_q = {left_neighbor, q, right_neighbor};

    wire [31:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_rule110_logic_32
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110 next state: (~left & center) | (center ^ right)
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
    localparam WIDTH = 32;

    // State registers for each 32-bit block
    wire [WIDTH-1:0] block_q[0:BLOCKS-1];
    wire [WIDTH-1:0] block_data[0:BLOCKS-1];
    
    // Partition input data into blocks
    genvar b;
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_partition_data
            assign block_data[b] = data[b*WIDTH +: WIDTH];
        end
    endgenerate

    // Registers for neighbor bits to pipeline them and reduce critical path
    reg [BLOCKS-1:0] reg_left_nbr_bits;  // left neighbor bit (MSB+1) from next block (or 0)
    reg [BLOCKS-1:0] reg_right_nbr_bits; // right neighbor bit (LSB-1) from previous block (or 0)

    // Generate wires for current MSB and LSB of each block to feed into neighbor regs
    wire msb_bits[0:BLOCKS-1];
    wire lsb_bits[0:BLOCKS-1];
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_msb_lsb
            assign msb_bits[b] = block_q[b][WIDTH-1]; // MSB of block b
            assign lsb_bits[b] = block_q[b][0];       // LSB of block b
        end
    endgenerate

    // On each clock, capture boundary bits for next cycle use as neighbors
    always @(posedge clk) begin
        if (load) begin
            // Initialize neighbor bits registers to zero on load, boundaries zero-padded
            reg_left_nbr_bits <= {BLOCKS{1'b0}};
            reg_right_nbr_bits <= {BLOCKS{1'b0}};
        end else begin
            integer i;
            // For each block:
            // left neighbor bit of block b = MSB bit of block b+1 (or 0 if last block)
            for (i = 0; i < BLOCKS; i = i + 1) begin
                if (i < BLOCKS-1)
                    reg_left_nbr_bits[i] <= msb_bits[i+1];
                else
                    reg_left_nbr_bits[i] <= 1'b0;
            end

            // right neighbor bit of block b = LSB bit of block b-1 (or 0 if first block)
            for (i = 0; i < BLOCKS; i = i + 1) begin
                if (i > 0)
                    reg_right_nbr_bits[i] <= lsb_bits[i-1];
                else
                    reg_right_nbr_bits[i] <= 1'b0;
            end
        end
    end

    // Instantiate all blocks with neighbor bits from pipeline registers
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_rule110_blocks
            Rule110Block32 block_inst (
                .clk(clk),
                .load(load),
                .data(block_data[b]),
                .left_neighbor(reg_left_nbr_bits[b]),
                .right_neighbor(reg_right_nbr_bits[b]),
                .q(block_q[b])
            );
        end
    endgenerate

    // Concatenate output q from block_q registers
    generate
        for (b = 0; b < BLOCKS; b = b + 1) begin : gen_q_concat
            assign q[b*WIDTH +: WIDTH] = block_q[b];
        end
    endgenerate

endmodule