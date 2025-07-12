module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity bit of the 8-bit input vector.
    // The parity bit is the XOR of all input bits.
    //
    // Using Verilog's reduction XOR operator (^) here
    // results in a balanced XOR tree after synthesis,
    // which minimizes logic depth and critical path,
    // reducing delay and power consumption.
    //
    // This continuous assignment defines purely combinational
    // logic with zero sequential elements, ensuring maximum clarity
    // and optimal power, performance, and area (PPA).
    assign parity = ^in;
endmodule