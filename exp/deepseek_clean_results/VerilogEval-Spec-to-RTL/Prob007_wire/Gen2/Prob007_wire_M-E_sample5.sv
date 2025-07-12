module TopModule (
    input in,
    output out
);
    // Implement as a 1-input LUT configured as a buffer
    // LUT configuration: out = in (truth table: 0->0, 1->1)
    reg [1:0] lut = 2'b01; // Configuration for wire behavior
    
    assign out = lut[in];
endmodule