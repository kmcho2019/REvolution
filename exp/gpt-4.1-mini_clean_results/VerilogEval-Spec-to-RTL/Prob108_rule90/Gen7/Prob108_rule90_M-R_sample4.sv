module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,     // left boundary (0 if no neighbor)
    input  wire        right_in,    // right boundary (0 if no neighbor)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_logic
            wire left  = (i == 0)   ? left_in  : q_out[i-1];
            wire right = (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Intermediate wires for each 64-bit block's current state
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Left boundary of block 0 and right boundary of block 7 are zero per specification
    assign left_bounds[0] = 1'b0;
    assign right_bounds[7] = 1'b0;

    genvar i;
    generate
        // Assign internal boundaries for blocks 1..7 and 0..6
        for (i = 1; i < 8; i = i + 1) begin : left_boundary_assign
            assign left_bounds[i] = block_q[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : right_boundary_assign
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    // Instantiate the 8 blocks
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 blk (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
        end
    endgenerate

    // Flatten block outputs into single 512-bit output vector
    generate
        for (i = 0; i < 8; i = i + 1) begin : output_assign
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule