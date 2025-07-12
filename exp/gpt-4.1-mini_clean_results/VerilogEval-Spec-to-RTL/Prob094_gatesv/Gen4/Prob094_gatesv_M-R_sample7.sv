module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3]=0
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0]=0
    assign out_any[0] = 1'b0;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // For out_different, we create a rotated version of in by shifting left by 1 with wrap-around,
    // then XOR bitwise with original in.
    wire [3:0] in_rotated_left;
    assign in_rotated_left = {in[2:0], in[3]}; // left neighbor wrapping from bit 3 to bit 0

    assign out_different = in ^ in_rotated_left;

endmodule