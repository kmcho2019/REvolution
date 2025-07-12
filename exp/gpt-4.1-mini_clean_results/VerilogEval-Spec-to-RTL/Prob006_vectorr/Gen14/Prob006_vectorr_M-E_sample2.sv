module TopModule (
    input  [7:0] in,
    output [7:0] out
);
    localparam WIDTH = 8;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse_loop
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate
endmodule