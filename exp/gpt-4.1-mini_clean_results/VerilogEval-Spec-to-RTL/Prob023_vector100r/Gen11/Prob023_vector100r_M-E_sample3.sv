module BitReverser #(parameter WIDTH = 100) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_rev_loop
            assign out[i] = in[WIDTH-1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    BitReverser #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule