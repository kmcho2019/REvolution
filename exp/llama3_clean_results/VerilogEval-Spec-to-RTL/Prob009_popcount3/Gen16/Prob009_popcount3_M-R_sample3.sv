module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire bit0_count;
    wire bit1_count;
    wire bit2_count;
    wire temp_sum;

    assign bit0_count = in[0] & 1'b1;
    assign bit1_count = in[1] & 1'b1;
    assign bit2_count = in[2] & 1'b1;

    assign temp_sum = bit0_count + bit1_count + bit2_count;

    assign out = temp_sum;

endmodule