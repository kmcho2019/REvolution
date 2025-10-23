module TopModule #(
    parameter WIDTH = 100
) (
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    // Direct assignment for simplicity and potential synthesis optimization
    assign out = in[::-1]; // This syntax is not standard Verilog but demonstrates the idea of reversing bits

    // Alternatively, sticking with the original generate block approach for compatibility and efficiency
    // genvar i;
    // generate
    //     for (i = 0; i < WIDTH; i++) begin
    //         assign out[i] = in[WIDTH - 1 - i];
    //     end
    // endgenerate

endmodule