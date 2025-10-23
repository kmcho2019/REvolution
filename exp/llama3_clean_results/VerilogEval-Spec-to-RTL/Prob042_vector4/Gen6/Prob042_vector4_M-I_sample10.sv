module TopModule(
    input wire [7:0] in,
    output wire [31:0] out
);

    // The current implementation is already quite efficient. For further optimization,
    // consider the specifics of the target technology library and the input data statistics.
    assign out = {{24{in[7]}}, in};

endmodule