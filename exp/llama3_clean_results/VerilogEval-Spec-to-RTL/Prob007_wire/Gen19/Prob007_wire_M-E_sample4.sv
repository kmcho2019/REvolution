// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Internal signal for the select line of the MUX
    logic sel;
    
    // Assign the select line to always select the input signal
    assign sel = 1'b0; // Selects the input signal
    
    // Implement the MUX to pass through the input signal
    assign out = (sel) ? 1'b0 : in; // If sel is 0, out = in; else out = 0

endmodule