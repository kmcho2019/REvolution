module TopModule(
    input a,
    input b,
    output out
);
    // 2-bit LUT implementation of AND gate
    reg [3:0] lut;
    
    initial begin
        lut = 4'b0001; // Only output 1 when both inputs are 1 (address 3)
    end
    
    assign out = lut[{a, b}];
endmodule