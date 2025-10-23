module TopModule #(
    parameter WIDTH = 32
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Byte reversal for any width that's a multiple of 8
    generate
        if (WIDTH == 32) begin
            assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
        // Can add other width cases here if needed
    endgenerate
endmodule