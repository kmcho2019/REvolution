module Rule110Block8 (
    input  wire        clk,
    input  wire        load,
    input  wire [7:0]  data,           // data to load for this block
    input  wire        left_neighbor,  // neighbor bit to the left of MSB (q[block*8+8])
    input  wire        right_neighbor, // neighbor bit to the right of LSB (q[block*8-1])
    output reg  [7:0]  q
);

    wire [9:0] ext_q = {left_neighbor, q, right_neighbor};
    wire [7:0] next_q;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_rule110_8
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110: next state = (~left & center) | (center ^ right);
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Clock enable: load or next_q != q
    wire clk_en = load | (next_q != q);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (clk_en)
            q <= next_q;
    end

endmodule


module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    localparam BLOCKS = 64; // 512/8
    wire [7:0] block_q[0:BLOCKS-1];
    wire [7:0] block_data[0:BLOCKS-1];

    genvar b;
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : gen_partition_data
            assign block_data[b] = data[b*8 +: 8];
        end
    endgenerate

    // Concatenate block_q to a big vector for easy neighbor bit extraction
    wire [511:0] assembled_q;
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : gen_q_concat
            assign assembled_q[b*8 +: 8] = block_q[b];
        end
    endgenerate

    // Neighbor bits for each block:
    // left_neighbor[b] = q[(b+1)*8] if b < BLOCKS-1 else 0
    // right_neighbor[b] = q[b*8 - 1] if b > 0 else 0
    wire [BLOCKS-1:0] left_neighbors;
    wire [BLOCKS-1:0] right_neighbors;

    generate
        for (b=0; b<BLOCKS; b=b+1) begin : gen_neighbors
            if (b < BLOCKS-1)
                assign left_neighbors[b] = assembled_q[(b+1)*8];
            else
                assign left_neighbors[b] = 1'b0;

            if (b > 0)
                assign right_neighbors[b] = assembled_q[b*8 - 1];
            else
                assign right_neighbors[b] = 1'b0;
        end
    endgenerate

    // Instantiate Rule110Block8 modules
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : gen_blocks
            Rule110Block8 block_inst (
                .clk(clk),
                .load(load),
                .data(block_data[b]),
                .left_neighbor(left_neighbors[b]),
                .right_neighbor(right_neighbors[b]),
                .q(block_q[b])
            );
        end
    endgenerate

    // Assign output q from block_q
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : gen_q_out
            assign q[b*8 +: 8] = block_q[b];
        end
    endgenerate

endmodule