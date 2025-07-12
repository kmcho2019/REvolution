module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // 2-bit address formed by inputs
    wire [1:0] addr = {a, b};
    
    // 4-entry LUT where [1] = cout, [0] = sum
    reg [1:0] lut [0:3];
    
    // Initialize LUT with half adder truth table
    initial begin
        lut[0] = 2'b00; // 0+0 = 0, cout=0
        lut[1] = 2'b01; // 0+1 = 1, cout=0
        lut[2] = 2'b01; // 1+0 = 1, cout=0
        lut[3] = 2'b10; // 1+1 = 0, cout=1
    end
    
    // Output assignments
    assign {cout, sum} = lut[addr];

endmodule