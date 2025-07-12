module TopModule #(
    parameter WIDTH = 16,
    parameter HALF_WIDTH = WIDTH/2
) (
    input  [WIDTH-1:0] in,
    output [HALF_WIDTH-1:0] out_hi,
    output [HALF_WIDTH-1:0] out_lo
);

    // Explicit wire declarations
    wire [HALF_WIDTH-1:0] out_hi;
    wire [HALF_WIDTH-1:0] out_lo;

    // Optimal direct bit selection
    assign out_hi = in[WIDTH-1:HALF_WIDTH];
    assign out_lo = in[HALF_WIDTH-1:0];

endmodule