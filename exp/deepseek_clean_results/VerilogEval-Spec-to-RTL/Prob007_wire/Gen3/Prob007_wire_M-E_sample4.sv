module TopModule (
    input in,
    output out
);
    // Implement as a 1-input LUT (Look-Up Table)
    // Truth table: 0->0, 1->1
    reg [1:0] lut = 2'b01; // [0] = 0, [1] = 1
    
    assign out = lut[in];
endmodule