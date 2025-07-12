module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left;
    wire [99:0] in_shifted_right;

    assign in_shifted_left[99] = in[0];
    assign in_shifted_left[98:0] = in[99:1];

    assign in_shifted_right[0] = in[99];
    assign in_shifted_right[99:1] = in[98:0];

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out_both[i] = in[i] & (i == 99 ? 1'b0 : in[i+1]);
            assign out_any[i] = in[i] | (i == 0 ? 1'b0 : in[i-1]);
            assign out_different[i] = in[i] ^ (i == 99 ? in[0] : in[i+1]);
        end
    endgenerate

endmodule