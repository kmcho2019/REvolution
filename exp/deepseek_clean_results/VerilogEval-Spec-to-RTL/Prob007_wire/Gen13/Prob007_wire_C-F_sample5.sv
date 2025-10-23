// Simple wire connection module
// Connects input directly to output with zero delay
module TopModule (
    input  in,   // Input signal
    output out   // Output (direct connection to input)
);
    assign out = in;  // Continuous assignment for optimal PPA
endmodule