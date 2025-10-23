// Refactored 8-bit 2-to-1 multiplexer module
module TopModule (
    input        sel, // Select signal
    input  [7:0] a,   // First 8-bit input
    input  [7:0] b,   // Second 8-bit input
    output [7:0] out  // Selected 8-bit output
);

    // Use a continuous assignment to select between 'a' and 'b' based on 'sel'
    // This approach is concise and efficient for a simple multiplexer
    assign out = sel? b : a;

    // Alternatively, for explicit bit-level control or debugging purposes,
    // the following could be used, but it's less concise and should behave
    // the same as the ternary operator in terms of functionality.
    // assign out = {8{sel? b[7] : a[7], sel? b[6] : a[6], sel? b[5] : a[5],
    //                sel? b[4] : a[4], sel? b[3] : a[3], sel? b[2] : a[2],
    //                sel? b[1] : a[1], sel? b[0] : a[0]}};

endmodule