// Novel Solution: Using a Lookup Table
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Define the lookup table as a parameterized array
    parameter logic [1:0] LUT = 2'b01; // Output for in=0 is 0, for in=1 is 1
    
    // Use the input to index into the LUT and assign the output
    assign out = LUT[in];
endmodule