module TopModule (
    input x,
    input y,
    output z
);
    // LUT-based implementation of z = (x^y) & x
    reg [3:0] lut;
    
    // Initialize LUT with truth table for z = (x^y) & x
    // Index is {x,y}, so:
    // 00: 0, 01: 0, 10: 1, 11: 0
    initial begin
        lut = 4'b0010;
    end
    
    assign z = lut[{x,y}];
endmodule