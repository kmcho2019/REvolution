module TopModule (
    input a,
    input b,
    output out
);
    // 2-bit address space for all input combinations
    wire [1:0] address = {a, b};
    
    // LUT storing NOR truth table
    reg [0:0] lut [0:3];
    
    initial begin
        lut[0] = 1'b1; // 00 -> 1
        lut[1] = 1'b0; // 01 -> 0
        lut[2] = 1'b0; // 10 -> 0
        lut[3] = 1'b0; // 11 -> 0
    end
    
    assign out = lut[address];
endmodule