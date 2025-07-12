module TopModule (
    input a,
    input b,
    output out
);
    reg [3:0] lut;
    
    initial begin
        // Initialize LUT with NOR truth table
        lut[0] = 1; // 00
        lut[1] = 0; // 01
        lut[2] = 0; // 10
        lut[3] = 0; // 11
    end
    
    assign out = lut[{a, b}];
endmodule