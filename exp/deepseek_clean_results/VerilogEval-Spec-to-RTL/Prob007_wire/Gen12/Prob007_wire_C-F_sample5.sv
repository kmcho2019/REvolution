// TopModule: Simple wire connection
// Directly connects input 'in' to output 'out' with zero delay
module TopModule (
    input  in,   // Input signal
    output out   // Output signal (directly connected to input)
);
    assign out = in;  // Continuous assignment for optimal PPA
endmodule