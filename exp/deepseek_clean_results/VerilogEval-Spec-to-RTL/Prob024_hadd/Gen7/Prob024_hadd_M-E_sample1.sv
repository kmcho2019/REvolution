module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // 2-bit address space (a,b) -> [sum, cout]
    reg [1:0] lut [0:3];
    
    initial begin
        // Initialize LUT with half adder truth table
        lut[0] = 2'b00; // 0+0 = 0, carry 0
        lut[1] = 2'b10; // 0+1 = 1, carry 0
        lut[2] = 2'b10; // 1+0 = 1, carry 0
        lut[3] = 2'b01; // 1+1 = 0, carry 1
    end
    
    // Use inputs as address to lookup results
    assign {sum, cout} = lut[{a, b}];

endmodule