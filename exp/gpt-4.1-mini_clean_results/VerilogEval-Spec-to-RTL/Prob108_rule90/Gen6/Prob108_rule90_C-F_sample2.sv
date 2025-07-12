module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left boundary (0 if no neighbor)
    input right_in,       // right boundary (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left = (i == 0)   ? left_in     : q_out[i-1];
            wire right= (i == 63)  ? right_in    : q_out[i+1];
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
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    // Signals for each 64-bit block output
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Left boundary of block0 and right boundary of block7 are zero as specified
    assign left_bounds[0] = 1'b0;
    assign right_bounds[7] = 1'b0;

    // Internal boundaries: rightmost bit of block i-1 is left boundary for block i
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : assign_left_bounds
            assign left_bounds[i] = block_q[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : assign_right_bounds
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    // Instantiate eight 64-bit Rule90 blocks
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