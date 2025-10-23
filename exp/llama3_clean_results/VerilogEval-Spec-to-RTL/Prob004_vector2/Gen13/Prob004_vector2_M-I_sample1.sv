module TopModule #(
    parameter WIDTH = 32
) (
    input  wire [WIDTH-1:0] in,  // Input vector
    output wire [WIDTH-1:0] out  // Output vector with bytes reversed
);

    wire [WIDTH-1:0] reversed_bytes;

    assign reversed_bytes = {in[7:0], in[15:8], in[23:16], in[31:24]};  // Reverse byte order
    assign out = reversed_bytes;  // Assign reversed bytes to output

endmodule