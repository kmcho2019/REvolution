module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left neighbor boundary (0 for leftmost block)
    input right_in,       // right neighbor boundary (0 for rightmost block)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : calc_next
            wire left = (i == 0)   ? left_in       : q_out[i-1];
            wire right= (i == 63)  ? right_in      : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) q_out <= data_in;
        else      q_out <= next_state;
    end
endmodule

module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    // Divide data/q into 8 blocks of 64 bits
    wire [7:0] left_bounds;   // left boundary inputs to each block
    wire [7:0] right_bounds;  // right boundary inputs to each block
    wire [63:0] block_q [7:0];

    // For left boundary of block0 and right boundary of block7, always zero
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    // For internal boundaries, neighbors come from adjacent blocks
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : set_left_bounds
            assign left_bounds[i] = block_q[i-1][63]; // rightmost cell of left block
        end
        for (i = 0; i < 7; i = i + 1) begin : set_right_bounds
            assign right_bounds[i] = block_q[i+1][0]; // leftmost cell of right block
        end
    endgenerate

    // Instantiate 8 blocks
    generate
        for (i = 0; i < 8; i = i + 1) begin : blocks
            Rule90Block64 block (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule