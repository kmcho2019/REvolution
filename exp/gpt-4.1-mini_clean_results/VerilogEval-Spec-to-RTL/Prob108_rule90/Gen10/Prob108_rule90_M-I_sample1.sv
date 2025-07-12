module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,
    input right_in,
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left = (i == 0)   ? left_in  : q_out[i-1];
            wire right= (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    wire state_changed;
    assign state_changed = |(q_out ^ next_state);

    wire clk_en = load | state_changed;

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (clk_en)
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

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            wire left_in;
            wire right_in;

            // Left neighbor input boundary
            assign left_in = (i == 0) ? 1'b0 : block_q[i-1][63];
            // Right neighbor input boundary
            assign right_in = (i == 7) ? 1'b0 : block_q[i+1][0];

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