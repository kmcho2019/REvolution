// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Define a 2:1 multiplexer to act as a buffer
    wire sel; // Select line for the multiplexer
    assign sel = 1'b0; // Always choose the first input
    
    // Instantiate the multiplexer
    // Input 0 is tied to the input signal, and input 1 is tied to a constant (0 in this case)
    assign out = (sel)? 1'b0 : in;

endmodule