module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Bit-slice module for out_both calculation
    module BothSlice(input a, input b, output out);
        assign out = a & b;
    endmodule

    // Bit-slice module for out_any calculation
    module AnySlice(input a, input b, output out);
        assign out = a | b;
    endmodule

    // Bit-slice module for out_different calculation
    module DiffSlice(input a, input b, output out);
        assign out = a ^ b;
    endmodule

    // Generate out_both slices (bits 2:0)
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : both_gen
            BothSlice bs(.a(in[i]), .b(in[i+1]), .out(out_both[i]));
        end
    endgenerate
    assign out_both[3] = 1'b0;  // Don't-care bit

    // Generate out_any slices (bits 3:1)
    generate
        for (i = 1; i < 4; i = i + 1) begin : any_gen
            AnySlice as(.a(in[i]), .b(in[i-1]), .out(out_any[i]));
        end
    endgenerate
    assign out_any[0] = 1'b0;  // Don't-care bit

    // Generate out_different slices (all bits with wrap-around)
    generate
        for (i = 0; i < 4; i = i + 1) begin : diff_gen
            DiffSlice ds(
                .a(in[i]),
                .b(i == 3 ? in[0] : in[i+1]),  // Wrap-around for bit 3
                .out(out_different[i])
            );
        end
    endgenerate

endmodule