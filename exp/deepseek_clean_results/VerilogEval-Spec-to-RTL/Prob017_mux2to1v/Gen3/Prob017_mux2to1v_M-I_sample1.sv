module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input             sel,
    output [WIDTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : mux_gen
            assign out[i] = (sel == 1'b0) ? a[i] : b[i];
        end
    endgenerate

endmodule