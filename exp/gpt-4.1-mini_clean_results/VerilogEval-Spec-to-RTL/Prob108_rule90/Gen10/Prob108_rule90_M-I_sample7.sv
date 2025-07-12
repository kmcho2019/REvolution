module Rule90Block32 (
    input  wire        clk,
    input  wire        load,
    input  wire [31:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [31:0] q_out
);
    // Next state calculation: each bit = xor of left and right neighbors
    wire [31:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 31)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock gating enable signal - update only when load or next_state differs
    wire update_enable = load | (q_out != next_state);

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (update_enable)
            q_out <= next_state;
        // else q_out holds value, reducing toggling and power
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // 16 blocks of 32 bits each
    wire [31:0] block_q [15:0];

    // Boundary signals for each block
    wire [15:0] left_bounds;
    wire [15:0] right_bounds;

    // Global fixed boundaries at the edges are zero
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[15] = 1'b0;

    genvar i;
    generate
        // Internal boundaries between blocks
        for (i = 1; i < 16; i = i + 1) begin : gen_left_bounds
            assign left_bounds[i] = block_q[i-1][31];  // rightmost bit of left block
        end
        for (i = 0; i < 15; i = i + 1) begin : gen_right_bounds
            assign right_bounds[i] = block_q[i+1][0];  // leftmost bit of right block
        end
    endgenerate

    // Instantiate 16 blocks of Rule90Block32
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_blocks
            Rule90Block32 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*32 +: 32]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*32 +: 32] = block_q[i];
        end
    endgenerate
endmodule