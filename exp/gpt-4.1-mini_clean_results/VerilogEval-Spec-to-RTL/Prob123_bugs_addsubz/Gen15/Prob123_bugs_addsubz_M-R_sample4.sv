module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_invert;
    wire [7:0] sum;
    wire [8:0] carry;

    assign b_invert = b ^ {8{do_sub}};
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_add_sub
            assign sum[i] = a[i] ^ b_invert[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_invert[i]) | (a[i] & carry[i]) | (b_invert[i] & carry[i]);
        end
    endgenerate

    assign out = sum;
    assign result_is_zero = ~|sum;

endmodule