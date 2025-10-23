module TopModule #(
    parameter WIDTH = 32, // Total width of the input vector
    parameter BYTE_SIZE = 8 // Size of each byte in bits
) (
    input  wire [WIDTH-1:0] in, // Input vector
    output wire [WIDTH-1:0] out // Output vector with bytes reversed
);

    // Assign the reversed bytes directly to the output
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule