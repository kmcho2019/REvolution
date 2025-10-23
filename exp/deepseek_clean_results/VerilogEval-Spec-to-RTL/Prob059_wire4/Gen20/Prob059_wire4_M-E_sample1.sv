module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Create a 4-bit vector for all outputs
    wire [3:0] outputs;
    
    // Assign outputs using concatenation
    assign outputs = {a, b, b, c};
    
    // Break out individual outputs
    assign w = outputs[3];
    assign x = outputs[2];
    assign y = outputs[1];
    assign z = outputs[0];
endmodule