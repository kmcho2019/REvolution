module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Alternative approach using conditional operators for population count
    assign out = (in[0] + in[1] + in[2]);

    // We maintain the simplicity of the direct arithmetic approach but explore optimizations for better PPA metrics.
    // This implementation remains straightforward and easy to understand while potentially offering improved area and power efficiency.

endmodule