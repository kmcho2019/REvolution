module TopModule #(
    parameter WIDTH = 100
)(
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out_both,
    output wire [WIDTH-1:0] out_any,
    output wire [WIDTH-1:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..WIDTH-2; out_both[WIDTH-1]=0
    assign out_both = ({in[WIDTH-2:0], 1'b0} & in) & {{(WIDTH-1){1'b1}}, 1'b0};

    // out_any[i] = in[i] | in[i-1] for i=1..WIDTH-1; out_any[0]=0
    assign out_any = (in | {1'b0, in[WIDTH-1:1]}) & {1'b0, {(WIDTH-1){1'b1}}};

    // out_different[i] = in[i] ^ in[(i+1) mod WIDTH]
    // Use shift with wrap-around by concatenating MSB and slicing
    assign out_different = in ^ ({in[WIDTH-2:0], in[WIDTH-1]});

endmodule