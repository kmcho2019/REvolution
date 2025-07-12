// TopModule: Constant high output driver
// This trivial implementation provides the most efficient way to drive a constant high output
// Synthesis will optimize this to a direct VDD connection
module TopModule(output one);
    assign one = 1'b1;  // Explicit 1-bit constant assignment
    
    /* Alternative implementations (commented out):
    // Option 2: Using always block
    // output reg one;
    // always @(*) one = 1'b1;
    
    // Option 3: Using parameter
    // parameter CONST_ONE = 1'b1;
    // assign one = CONST_ONE;
    */
endmodule