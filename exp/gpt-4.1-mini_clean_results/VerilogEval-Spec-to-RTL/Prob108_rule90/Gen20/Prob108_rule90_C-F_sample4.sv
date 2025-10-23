module Rule90Block64 #(
    parameter WIDTH = 64
) (
    input  wire              clk,
    input  wire              load,
    input  wire [WIDTH-1:0]  data_in,
    input  wire              left_in,   // left neighbor boundary (0 if none)
    input  wire              right_in,  // right neighbor boundary (0 if none)
    output reg  [WIDTH-1:0]  q_out
);
    wire [WIDTH-1:0] next_state;

    // For indices 1 to WIDTH-2, next_state is q_out[i-1] ^ q_out[i+1]
    // For boundaries, use left_in and right_in respectively
    // Use vector concatenation and shift operations for cleaner logic

    // Construct left neighbor vector: left_in + q_out[WIDTH-1:1]
    wire [WIDTH-1:0] left_neighbors  = {q_out[WIDTH-2:0], right_in};
    wire [WIDTH-1:0] right_neighbors = {left_in, q_out[WIDTH-1:1]};

    // next_state[i] = left_neighbors[i] ^ right_neighbors[i]
    assign next_state = left_neighbors ^ right_neighbors;

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
    localparam WIDTH  = 64;

    wire [WIDTH-1:0] block_q [0:BLOCKS-1];
    wire [BLOCKS-1:0] left_bounds;
    wire [BLOCKS-1:0] right_bounds;

    // Assign global boundaries to zero
    assign left_bounds[0]       = 1'b0;
    assign right_bounds[BLOCKS-1] = 1'b0;

    genvar i;
    generate
        // Internal boundary connections: each block's left boundary is previous block's MSB
        for (i = 1; i < BLOCKS; i = i + 1) begin : gen_left_bounds
            assign left_bounds[i] = block_q[i-1][WIDTH-1];
        end
        // Each block's right boundary is next block's LSB
        for (i = 0; i < BLOCKS-1; i = i + 1) begin : gen_right_bounds
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    generate
        for (i = 0; i < BLOCKS; i = i + 1) begin : gen_blocks
            Rule90Block64 #(.WIDTH(WIDTH)) block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*WIDTH +: WIDTH]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*WIDTH +: WIDTH] = block_q[i];
        end
    endgenerate
endmodule