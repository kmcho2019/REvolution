module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable: update on load or if next_state differs from current q_out
    wire ce = load | |(next_state ^ q_out);

    always @(posedge clk) begin
        if (ce) begin
            if (load)
                q_out <= data_in;
            else
                q_out <= next_state;
        end
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal state registers for each 64-bit block
    wire [63:0] block_q [7:0];

    // Boundary signals for each block
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Assign zero to the left boundary of the first block and right boundary of the last block
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    genvar i;
    generate
        // Internal boundaries between blocks: connect rightmost bit of left block to left boundary of right block
        for (i = 1; i < 8; i = i + 1) begin : gen_left_bounds
            assign left_bounds[i] = block_q[i-1][63];
        end
        // Internal boundaries between blocks: connect leftmost bit of right block to right boundary of left block
        for (i = 0; i < 7; i = i + 1) begin : gen_right_bounds
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

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