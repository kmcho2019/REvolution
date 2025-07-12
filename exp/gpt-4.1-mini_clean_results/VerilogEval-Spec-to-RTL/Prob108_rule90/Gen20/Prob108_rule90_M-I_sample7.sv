module Rule90Block64 #(
    parameter WIDTH = 64
)(
    input  wire             clk,
    input  wire             load,
    input  wire [WIDTH-1:0] data_in,
    input  wire             left_in,
    input  wire             right_in,
    output reg  [WIDTH-1:0] q_out
);
    // Create left and right neighbor vectors by concatenating boundary bits and q_out shifted
    wire [WIDTH-1:0] left_vec  = {q_out[WIDTH-2:0], right_in};
    wire [WIDTH-1:0] right_vec = {left_in, q_out[WIDTH-1:1]};

    // Next state is XOR of left and right neighbors per Rule 90
    wire [WIDTH-1:0] next_state = left_vec ^ right_vec;

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
    localparam BLOCKS = 8;
    localparam WIDTH = 64;

    // Internal storage per block
    wire [WIDTH-1:0] block_q [0:BLOCKS-1];

    // Concatenate block outputs to form q output
    genvar i;
    generate
        for (i = 0; i < BLOCKS; i = i + 1) begin : assign_q
            assign q[i*WIDTH +: WIDTH] = block_q[i];
        end
    endgenerate

    // Create left and right boundaries vectors for blocks
    // left_boundaries[i] = right edge of block i-1, zero for i=0
    // right_boundaries[i] = left edge of block i+1, zero for i=BLOCKS-1

    wire [BLOCKS-1:0] left_boundaries;
    wire [BLOCKS-1:0] right_boundaries;

    assign left_boundaries = {block_q[6][WIDTH-1], block_q[5][WIDTH-1], block_q[4][WIDTH-1], block_q[3][WIDTH-1], block_q[2][WIDTH-1], block_q[1][WIDTH-1], block_q[0][WIDTH-1], 1'b0};
    assign right_boundaries = {1'b0, block_q[1][0], block_q[2][0], block_q[3][0], block_q[4][0], block_q[5][0], block_q[6][0], block_q[7][0]};

    // Instantiate each Rule90Block64 with proper boundaries and data_in slice
    generate
        for (i = 0; i < BLOCKS; i = i + 1) begin : rule90_blocks
            Rule90Block64 #(.WIDTH(WIDTH)) block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*WIDTH +: WIDTH]),
                .left_in(left_boundaries[i]),
                .right_in(right_boundaries[i]),
                .q_out(block_q[i])
            );
        end
    endgenerate
endmodule