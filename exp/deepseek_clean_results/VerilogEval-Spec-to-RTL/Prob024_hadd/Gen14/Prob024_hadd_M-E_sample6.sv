module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // LUT-based implementation
    reg [1:0] half_adder_lut [0:3];
    
    initial begin
        half_adder_lut[0] = 2'b00;  // 0+0 = 00
        half_adder_lut[1] = 2'b10;  // 0+1 = 01
        half_adder_lut[2] = 2'b10;  // 1+0 = 01
        half_adder_lut[3] = 2'b01;  // 1+1 = 10
    end
    
    wire [1:0] result;
    assign result = half_adder_lut[{a,b}];
    assign {cout, sum} = result;
endmodule