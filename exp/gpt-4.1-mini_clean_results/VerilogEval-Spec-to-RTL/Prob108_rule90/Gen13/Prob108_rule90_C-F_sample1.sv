module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left neighbor bit (0 if no neighbor)
    input right_in,       // right neighbor bit (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            // Left neighbor: left_in for bit 0, else q_out[i-1]
            wire left  = (i == 0)  ? left_in  : q_out[i-1];
            // Right neighbor: right_in for bit 63, else q_out[i+1]
            wire right = (i == 63) ? right_in : q_out[i+1];
            // Rule 90: next state is XOR of left and right neighbors
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Sequential logic: on load, load data_in; otherwise update to next_state
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
    // Internal 64-bit registers for each of 8 blocks
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks
    // left_bounds[i] is left neighbor bit for block i's bit 0
    // right_bounds[i] is right neighbor bit for block i's bit 63
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Boundary wiring:
    // Left boundary of first block is 0 (no neighbor to the left)
    // Right boundary of last block is 0 (no neighbor to the right)
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    // For i in [1..7], left_bounds[i] = block_q[i-1][63]
    // For i in [0..6], right_bounds[i] = block_q[i+1][0]
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : left_bound_assign
            assign left_bounds[i] = block_q[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : right_bound_assign
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    // Instantiate 8 Rule90Block64 modules for the 512 bits
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