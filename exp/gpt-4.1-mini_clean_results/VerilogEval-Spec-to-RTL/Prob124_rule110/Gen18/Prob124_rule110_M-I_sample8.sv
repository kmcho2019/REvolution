module Rule110Block16 (
    input  wire         clk,
    input  wire         load,
    input  wire         ce,
    input  wire [15:0]  data,           // data to load for this block
    input  wire         left_neighbor,  // neighbor bit to the left of MSB (q[block*16+16])
    input  wire         right_neighbor, // neighbor bit to the right of LSB (q[block*16-1])
    output reg  [15:0]  q               // current block state
);
    // Extended state with neighbor bits for easy indexing: {left_neighbor, q, right_neighbor}
    wire [17:0] ext_q;
    assign ext_q = {left_neighbor, q, right_neighbor};

    // Next state logic per bit
    wire [15:0] next_q;
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : gen_rule110_logic_16
            wire left   = ext_q[i+2]; // left neighbor bit: index one higher
            wire center = ext_q[i+1]; // current bit
            wire right  = ext_q[i];   // right neighbor bit: index one lower
            // Rule 110 next state boolean expression (equiv. to given truth table):
            // next = (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ce)
            q <= next_q;
    end

endmodule


module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    localparam BLOCKS = 32; // 512/16
    // Current block states
    wire [15:0] block_q [0:BLOCKS-1];

    // Registered neighbor bits from previous state q to break combinational loops and reduce fanout
    reg [BLOCKS-1:0] neighbor_left_reg;   // left neighbor bits of each block (boundary bits on left side)
    reg [BLOCKS-1:0] neighbor_right_reg;  // right neighbor bits of each block (boundary bits on right side)

    // Inputs to blocks: left and right neighbors from registered values to reduce fanout and timing pressure
    wire [BLOCKS-1:0] left_neighbor_in;
    wire [BLOCKS-1:0] right_neighbor_in;

    // Load data per block
    wire [15:0] block_data [0:BLOCKS-1];

    genvar b;
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : partition_data
            assign block_data[b] = data[b*16 +: 16];
        end
    endgenerate

    // Assemble full q output from block outputs
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : assemble_q
            assign q[b*16 +: 16] = block_q[b];
        end
    endgenerate

    // Compute neighbor bits from current q for registering
    // Neighbor left of block b is q[(b+1)*16] if b < BLOCKS-1 else 0
    // Neighbor right of block b is q[b*16 - 1] if b > 0 else 0
    wire [BLOCKS-1:0] neighbor_left_wire;
    wire [BLOCKS-1:0] neighbor_right_wire;

    generate
        for (b=0; b<BLOCKS; b=b+1) begin : neighbor_bits_compute
            if (b < BLOCKS-1)
                assign neighbor_left_wire[b] = q[(b+1)*16];
            else
                assign neighbor_left_wire[b] = 1'b0;

            if (b > 0)
                assign neighbor_right_wire[b] = q[(b*16)-1];
            else
                assign neighbor_right_wire[b] = 1'b0;
        end
    endgenerate

    // Register neighbor bits to break combinational feedback paths and fanout
    always @(posedge clk) begin
        if (load) begin
            neighbor_left_reg  <= 0; // load state replaces all q, so neighbors reset to zero for one cycle
            neighbor_right_reg <= 0;
        end else begin
            neighbor_left_reg  <= neighbor_left_wire;
            neighbor_right_reg <= neighbor_right_wire;
        end
    end

    assign left_neighbor_in  = neighbor_left_reg;
    assign right_neighbor_in = neighbor_right_reg;

    // Clock enable for update: active when not loading
    wire ce = ~load;

    // Instantiate blocks with registered neighbor inputs to reduce timing stress
    generate
        for (b=0; b<BLOCKS; b=b+1) begin : inst_blocks
            Rule110Block16 block_inst (
                .clk(clk),
                .load(load),
                .ce(ce),
                .data(block_data[b]),
                .left_neighbor(left_neighbor_in[b]),
                .right_neighbor(right_neighbor_in[b]),
                .q(block_q[b])
            );
        end
    endgenerate

endmodule