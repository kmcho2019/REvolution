module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Create a 4-bit bus combining all inputs with duplicates
    wire [3:0] bus = {a, b, b, c};
    
    // Assign outputs from the bus
    assign w = bus[3];
    assign x = bus[2];
    assign y = bus[1];
    assign z = bus[0];
endmodule