module Rule90Block64Next (
    input  wire [63:0] current_state,
    input  wire        left_in,
    input  wire        right_in,
    output wire [63:0] next_state
);
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : current_state[i-1];
            wire right = (i == 63)  ? right_in     : current_state[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate
endmodule

module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    reg [511:0] q_reg;

    wire [511:0] next_state;

    // Split current q_reg into 8 blocks of 64 bits for neighbor passing
    wire [63:0] blocks [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : split_blocks
            assign blocks[i] = q_reg[i*64 +: 64];
        end
    endgenerate

    // Boundaries are zero at edges
    wire [7:0] left_in_bounds;
    wire [7:0] right_in_bounds;

    assign left_in_bounds[0]  = 1'b0;
    assign right_in_bounds[7] = 1'b0;

    // Internal boundaries between blocks
    generate
        for (i = 1; i < 8; i = i + 1) begin : left_bounds_gen
            assign left_in_bounds[i] = blocks[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : right_bounds_gen
            assign right_in_bounds[i] = blocks[i+1][0];
        end
    endgenerate

    // Instantiate 8 combinational next state blocks
    wire [63:0] next_blocks [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : next_state_blocks
            Rule90Block64Next next_block_inst (
                .current_state(blocks[i]),
                .left_in(left_in_bounds[i]),
                .right_in(right_in_bounds[i]),
                .next_state(next_blocks[i])
            );
            assign next_state[i*64 +: 64] = next_blocks[i];
        end
    endgenerate

    // State update on clock edge
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

    assign q = q_reg;
endmodule