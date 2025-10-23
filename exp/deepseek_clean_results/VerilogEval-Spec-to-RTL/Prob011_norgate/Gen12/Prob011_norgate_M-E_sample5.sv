module TopModule (
    input  a,    // First input signal
    input  b,    // Second input signal
    output out   // NOR gate output
);
    // LUT-based NOR implementation
    reg [3:0] lut;
    
    initial begin
        // Initialize LUT with NOR truth table:
        // Address 00 (a=0, b=0) -> 1
        // Address 01 (a=0, b=1) -> 0
        // Address 10 (a=1, b=0) -> 0
        // Address 11 (a=1, b=1) -> 0
        lut = 4'b1000;
    end
    
    // Use concatenated inputs as address
    assign out = lut[{a, b}];
endmodule