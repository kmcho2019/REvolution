module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // Left neighbor boundary (0 if none)
    input  wire        right_in,  // Right neighbor boundary (0 if none)
    output reg  [63:0] q_out
);
    // Calculate next state: each cell = XOR of left and right neighbors
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
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
    wire [63:0] block_q [7:0];

    // Boundary bits for blocks
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Global boundaries (outside the 512-cell array) are zero
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    genvar i;
    generate
        // Internal left boundaries: left_bounds[i] = rightmost bit of block_q[i-1]
        for (i = 1; i < 8; i = i + 1) begin : gen_left_bounds
            assign left_bounds[i] = block_q[i-1][63];
        end
        // Internal right boundaries: right_bounds[i] = leftmost bit of block_q[i+1]
        for (i = 0; i < 7; i = i + 1) begin : gen_right_bounds
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    // Instantiate 8 blocks of 64 bits each
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_blocks
            Rule90Block64 block_inst (
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