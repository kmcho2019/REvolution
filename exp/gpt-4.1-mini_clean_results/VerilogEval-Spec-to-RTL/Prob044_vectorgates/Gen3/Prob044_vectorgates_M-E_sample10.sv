module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_bitwise_temp;
    wire [2:0] not_a;
    wire [2:0] not_b;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_ops
            assign or_bitwise_temp[i] = a[i] | b[i];
            assign not_a[i] = ~a[i];
            assign not_b[i] = ~b[i];
        end
    endgenerate

    assign out_or_bitwise = or_bitwise_temp;
    assign out_or_logical = |or_bitwise_temp;
    assign out_not = {not_b, not_a};

endmodule