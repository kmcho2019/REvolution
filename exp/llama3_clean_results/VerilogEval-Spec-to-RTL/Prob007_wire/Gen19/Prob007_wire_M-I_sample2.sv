// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Direct assignment to minimize area and power consumption
    assign out = in;

endmodule