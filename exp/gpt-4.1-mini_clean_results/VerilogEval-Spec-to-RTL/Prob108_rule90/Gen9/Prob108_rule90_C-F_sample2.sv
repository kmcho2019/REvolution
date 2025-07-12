module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    wire [63:0] next_state;
    wire        ce; // clock enable: update only if load or state changes

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable: enable update if load or state changes
    wire state_changed = |(q_out ^ next_state);
    assign ce = load | state_changed;

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (ce)
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal wiring for 8 blocks of 64 bits each
    wire [63:0] block_q [7:0];

    // Declare boundary wires between blocks as single wires, not arrays, to reduce fanout
    wire b0_right;
    wire b1_left, b1_right;
    wire b2_left, b2_right;
    wire b3_left, b3_right;
    wire b4_left, b4_right;
    wire b5_left, b5_right;
    wire b6_left, b6_right;
    wire b7_left;

    // Assign boundaries explicitly
    // Edges are zero as per specification
    // Each internal boundary connects adjacent blocks

    // Block 0 boundaries
    assign b0_right = block_q[0][63];
    // Block 1 boundaries
    assign b1_left  = b0_right;
    assign b1_right = block_q[1][63];
    // Block 2 boundaries
    assign b2_left  = b1_right;
    assign b2_right = block_q[2][63];
    // Block 3 boundaries
    assign b3_left  = b2_right;
    assign b3_right = block_q[3][63];
    // Block 4 boundaries
    assign b4_left  = b3_right;
    assign b4_right = block_q[4][63];
    // Block 5 boundaries
    assign b5_left  = b4_right;
    assign b5_right = block_q[5][63];
    // Block 6 boundaries
    assign b6_left  = b5_right;
    assign b6_right = block_q[6][63];
    // Block 7 boundaries
    assign b7_left  = b6_right;
    // Right edge boundary zero
    wire b7_right = 1'b0;
    // Left edge boundary zero
    wire b0_left  = 1'b0;

    // Instantiate blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_blocks
            wire left_in;
            wire right_in;

            // Assign left_in and right_in for each block
            if (i == 0) begin
                assign left_in = b0_left;
                assign right_in= b0_right;
            end else if (i == 1) begin
                assign left_in = b1_left;
                assign right_in= b1_right;
            end else if (i == 2) begin
                assign left_in = b2_left;
                assign right_in= b2_right;
            end else if (i == 3) begin
                assign left_in = b3_left;
                assign right_in= b3_right;
            end else if (i == 4) begin
                assign left_in = b4_left;
                assign right_in= b4_right;
            end else if (i == 5) begin
                assign left_in = b5_left;
                assign right_in= b5_right;
            end else if (i == 6) begin
                assign left_in = b6_left;
                assign right_in= b6_right;
            end else begin // i == 7
                assign left_in = b7_left;
                assign right_in= b7_right;
            end

            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_in),
                .right_in(right_in),
                .q_out(block_q[i])
            );

            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule