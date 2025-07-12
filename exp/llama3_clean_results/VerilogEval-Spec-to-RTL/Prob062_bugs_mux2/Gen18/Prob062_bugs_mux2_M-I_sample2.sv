// Improved TopModule: An 8-bit 2-to-1 multiplexer
module TopModule (
    // Select signal: 0 selects 'a', 1 selects 'b'
    input        sel,
    // 8-bit input vector 'a'
    input  [7:0] a,
    // 8-bit input vector 'b'
    input  [7:0] b,
    // Selected 8-bit output vector
    output [7:0] out
);

    // Use ternary operator to select between 'a' and 'b' based on 'sel'
    assign out = sel ? b : a;

endmodule