module Rule90Block32 (
    input  wire        clk,
    input  wire        load,
    input  wire [31:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [31:0] q_out
);
    reg [31:0] next_state;

    integer i;
    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            // Determine left neighbor
            // If i==0, left neighbor = left_in; else q_out[i-1]
            // Determine right neighbor
            // If i==31, right neighbor = right_in; else q_out[i+1]
            next_state[i] = ((i == 0)   ? left_in      : q_out[i-1]) ^
                            ((i == 31)  ? right_in     : q_out[i+1]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // 16 blocks of 32 bits each
    wire [31:0] block_q [15:0];

    genvar i;

    // Instantiate 16 blocks
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_blocks
            // Determine left boundary for block i
            wire left_bound = (i == 0) ? 1'b0 : block_q[i-1][31];
            // Determine right boundary for block i
            wire right_bound = (i == 15) ? 1'b0 : block_q[i+1][0];

            Rule90Block32 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*32 +: 32]),
                .left_in(left_bound),
                .right_in(right_bound),
                .q_out(block_q[i])
            );

            assign q[i*32 +: 32] = block_q[i];
        end
    endgenerate

endmodule