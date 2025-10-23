module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // left boundary (0 if no neighbor)
    input  wire        right_in,   // right boundary (0 if no neighbor)
    output reg  [63:0] q_out
);
    // Intermediate wire for next state calculation
    wire [63:0] next_state;

    // Compute next_state:
    // For bits 1 to 62: next_state[i] = q_out[i-1] ^ q_out[i+1]
    // For bit 0: next_state[0] = left_in ^ q_out[1]
    // For bit 63: next_state[63] = q_out[62] ^ right_in

    assign next_state[0]   = left_in ^ q_out[1];
    assign next_state[63]  = q_out[62] ^ right_in;
    assign next_state[62:1] = q_out[61:0] ^ q_out[63:2];

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
    // Eight 64-bit blocks storing current states
    wire [63:0] block_q [7:0];

    // Boundary signals for each block's left and right neighbors
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    genvar i;

    // Assign boundary inputs compactly:
    // For block i: left_in = 0 if i == 0 else MSB of block_q[i-1]
    //              right_in = 0 if i == 7 else LSB of block_q[i+1]
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries
            assign left_bounds[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Instantiate 8 Rule90Block64 modules for the 512-cell array
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