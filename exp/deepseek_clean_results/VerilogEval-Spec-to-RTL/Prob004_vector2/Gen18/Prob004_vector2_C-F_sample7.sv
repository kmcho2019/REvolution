module TopModule #(
    parameter WIDTH = 32
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Parameter check for valid byte-reversible widths
    initial begin
        if (WIDTH % 8 != 0) begin
            $error("TopModule: Width must be byte-aligned (multiple of 8)");
        end
    end

    // Direct byte reversal with parameterized width
    generate
        if (WIDTH == 32) begin
            // Optimized path for 32-bit case
            assign out = {in[7:0],   in[15:8], 
                          in[23:16], in[31:24]};
        end else begin
            // Generic byte reversal for other widths
            genvar i;
            for (i = 0; i < WIDTH/8; i = i + 1) begin
                assign out[i*8 +: 8] = in[WIDTH-8*(i+1) +: 8];
            end
        end
    endgenerate
endmodule