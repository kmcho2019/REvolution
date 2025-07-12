// Define the TopModule that directly implements the required logic
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly implement the logic based on the observation from the simulation waveforms
    assign q = (a | b) & (c | d);
    
endmodule