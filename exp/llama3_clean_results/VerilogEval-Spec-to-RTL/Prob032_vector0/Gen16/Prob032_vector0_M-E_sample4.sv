module TopModule #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] out_bits
);

    assign outv = vec;
    assign out_bits = vec;

    // Alternatively, for direct bit assignment as separate outputs:
    // genvar i;
    // generate
    //     for (i = 0; i < WIDTH; i++) begin
    //         assign out_bits[i] = vec[i];
    //     end
    // endgenerate

endmodule