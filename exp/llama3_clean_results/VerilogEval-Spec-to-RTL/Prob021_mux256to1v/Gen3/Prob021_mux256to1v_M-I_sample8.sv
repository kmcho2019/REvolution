module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // The existing code is already quite optimized for a 256-to-1 multiplexer.
    // However, we can explore using a case statement for potential optimization,
    // though this is typically less efficient than the current implementation.

    // Alternative implementation using a for loop and case statement for each bit
    // is not necessary given the efficient nature of the current implementation.

    // Directly using the provided implementation with considerations for synthesis tool optimizations
    assign out = in[sel * 4 +: 4];

endmodule