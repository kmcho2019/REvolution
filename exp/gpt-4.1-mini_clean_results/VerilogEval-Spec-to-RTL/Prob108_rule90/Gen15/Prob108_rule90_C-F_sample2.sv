module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    // Compute next_state as XOR of neighbors using vector shift and XOR
    // Boundary bits replaced by left_in/right_in zeros outside the vector
    // (q_out << 1) inserts a zero at LSB replaced by left_in
    // (q_out >> 1) inserts a zero at MSB replaced by right_in
    wire [63:0] q_left_shifted  = {q_out[62:0], left_in};
    wire [63:0] q_right_shifted = {right_in, q_out[63:1]};
    assign next_state = q_left_shifted ^ q_right_shifted;

    // Clock enable: update if load asserted or next_state differs from current state
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
    // Internal 64-bit blocks
    wire [63:0] block_q [7:0];

    // Boundary signals per block
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Global zero boundaries at the two ends
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    genvar i;
    generate
        // Internal boundaries: rightmost bit of block i-1 is left boundary of block i
        for (i = 1; i < 8; i = i + 1) begin : gen_left_bounds
            assign left_bounds[i] = block_q[i-1][63];
        end

        // Internal boundaries: leftmost bit of block i+1 is right boundary of block i
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