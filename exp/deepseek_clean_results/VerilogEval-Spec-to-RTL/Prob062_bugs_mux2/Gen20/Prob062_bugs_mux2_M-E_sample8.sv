module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Create an 8-bit mask from the sel signal
    wire [7:0] mask = {8{sel}};
    
    // Compute output using bitwise operations
    assign out = (a & ~mask) | (b & mask);

endmodule