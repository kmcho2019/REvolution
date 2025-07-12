module Rule90Block64 (
    input  clk,
    input  load,
    input  [63:0] data_in,
    input  left_in,    // left neighbor bit (0 if none)
    input  right_in,   // right neighbor bit (0 if none)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left  = (i == 0)  ? left_in  : q_out[i-1];
            wire right = (i == 63) ? right_in : q_out[i+1];
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
    wire [63:0] block_q [7:0];

    // Left and right boundaries between blocks:
    // left boundary for block0 = 0 (zero padding)
    // right boundary for block7 = 0 (zero padding)
    // inner boundaries connect q[bit] across blocks

    wire [6:0] inter_left_bounds;  // left boundary bits for blocks 1 to 7
    wire [6:0] inter_right_bounds; // right boundary bits for blocks 0 to 6

    genvar i;
    generate
        // Connect boundaries between adjacent 64-bit blocks
        for (i = 1; i < 8; i = i + 1) begin : boundary_connections
            assign inter_left_bounds[i-1]  = block_q[i-1][63]; // last bit previous block
            assign inter_right_bounds[i-1] = block_q[i][0];    // first bit current block
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : blocks
            wire left_bit  = (i == 0) ? 1'b0 : inter_left_bounds[i-1];
            wire right_bit = (i == 7) ? 1'b0 : inter_right_bounds[i];
            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bit),
                .right_in(right_bit),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule