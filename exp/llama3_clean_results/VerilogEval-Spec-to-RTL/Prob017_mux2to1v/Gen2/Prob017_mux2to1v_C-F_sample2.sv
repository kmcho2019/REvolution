// Module: TopModule
// Description: Implements a 2-1 multiplexer.
// Parameters: None
// Ports: 
//   - a: 100-bit input
//   - b: 100-bit input
//   - sel: 1-bit select signal
//   - out: 100-bit output

module TopModule(
    input  [99:0] a,  // 100-bit input a
    input  [99:0] b,  // 100-bit input b
    input         sel,  // 1-bit select signal
    output [99:0] out  // 100-bit output
);

    // Use the conditional operator to select between 'a' and 'b' based on 'sel'
    assign out = sel ? b : a;

endmodule