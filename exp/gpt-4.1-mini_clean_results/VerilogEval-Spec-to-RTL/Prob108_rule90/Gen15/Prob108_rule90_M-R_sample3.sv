module Rule90Block64 (
    input  wire [63:0] q_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output wire [63:0] next_state_out
);
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)  ? left_in      : q_in[i-1];
            wire right = (i == 63) ? right_in     : q_in[i+1];
            assign next_state_out[i] = left ^ right;
        end
    endgenerate
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    reg [511:0] q_reg;

    // Wires for block boundaries
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Partition q_reg into 8 blocks of 64 bits each
    wire [63:0] q_blocks [7:0];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : assign_q_blocks
            assign q_blocks[i] = q_reg[i*64 +: 64];
        end
    endgenerate

    // Boundaries between blocks
    // Global edges fixed zero
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    generate
        for (i = 1; i < 8; i = i + 1) begin : assign_left_bounds
            assign left_bounds[i] = q_blocks[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : assign_right_bounds
            assign right_bounds[i] = q_blocks[i+1][0];
        end
    endgenerate

    // Next state wires
    wire [63:0] next_state_blocks [7:0];

    // Instantiate combinational blocks to compute next states
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_blocks
            Rule90Block64 block_inst (
                .q_in(q_blocks[i]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .next_state_out(next_state_blocks[i])
            );
        end
    endgenerate

    // Concatenate all next state blocks into one vector
    wire [511:0] next_state_full;
    generate
        for (i = 0; i < 8; i = i + 1) begin : concat_next_state
            assign next_state_full[i*64 +: 64] = next_state_blocks[i];
        end
    endgenerate

    // State register update
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state_full;
    end

    assign q = q_reg;

endmodule