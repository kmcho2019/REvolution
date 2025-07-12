module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left boundary (0 if no neighbor)
    input right_in,       // right boundary (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;
    wire ce;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left = (i == 0)   ? left_in  : q_out[i-1];
            wire right= (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable: update if loading or next_state differs from current state
    assign ce = load | |(next_state ^ q_out);

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
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    wire [63:0] block_q [7:0];

    // Boundary signals for each block
    // For block i: left boundary is block_q[i-1][63], right boundary is block_q[i+1][0]
    // For block 0 left boundary = 0, for block 7 right boundary = 0
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    assign left_bounds[0] = 1'b0;
    assign right_bounds[7] = 1'b0;

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : boundaries
            assign left_bounds[i] = block_q[i-1][63];
            assign right_bounds[i-1] = block_q[i][0];
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
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