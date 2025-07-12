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
            wire left  = (i == 0)   ? left_in  : q_out[i-1];
            wire right = (i == 63)  ? right_in : q_out[i+1];
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
    // Internal signals for each 64-bit block output
    wire [63:0] q0, q1, q2, q3, q4, q5, q6, q7;

    // Clock gating: gate clock for blocks to reduce toggling during load cycles
    wire gated_clk = clk & (~load);

    // Boundaries between blocks
    // External boundaries fixed to zero
    wire left_bound_0 = 1'b0;
    wire right_bound_7 = 1'b0;

    wire left_bound_1  = q0[63];
    wire right_bound_0 = q1[0];

    wire left_bound_2  = q1[63];
    wire right_bound_1 = q2[0];

    wire left_bound_3  = q2[63];
    wire right_bound_2 = q3[0];

    wire left_bound_4  = q3[63];
    wire right_bound_3 = q4[0];

    wire left_bound_5  = q4[63];
    wire right_bound_4 = q5[0];

    wire left_bound_6  = q5[63];
    wire right_bound_5 = q6[0];

    wire left_bound_7  = q6[63];
    wire right_bound_6 = q7[0];

    Rule90Block64 block0 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[ 63:  0]),
        .left_in(left_bound_0),
        .right_in(right_bound_0),
        .q_out(q0)
    );
    Rule90Block64 block1 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[127: 64]),
        .left_in(left_bound_1),
        .right_in(right_bound_1),
        .q_out(q1)
    );
    Rule90Block64 block2 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[191:128]),
        .left_in(left_bound_2),
        .right_in(right_bound_2),
        .q_out(q2)
    );
    Rule90Block64 block3 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[255:192]),
        .left_in(left_bound_3),
        .right_in(right_bound_3),
        .q_out(q3)
    );
    Rule90Block64 block4 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[319:256]),
        .left_in(left_bound_4),
        .right_in(right_bound_4),
        .q_out(q4)
    );
    Rule90Block64 block5 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[383:320]),
        .left_in(left_bound_5),
        .right_in(right_bound_5),
        .q_out(q5)
    );
    Rule90Block64 block6 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[447:384]),
        .left_in(left_bound_6),
        .right_in(right_bound_6),
        .q_out(q6)
    );
    Rule90Block64 block7 (
        .clk(gated_clk),
        .load(load),
        .data_in(data[511:448]),
        .left_in(left_bound_7),
        .right_in(right_bound_7),
        .q_out(q7)
    );

    // Concatenate all block outputs to form the full 512-bit output
    assign q = {q7, q6, q5, q4, q3, q2, q1, q0};
endmodule