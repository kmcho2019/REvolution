// LUT-Based Full Adder Module
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Define the look-up table for the full adder
reg [1:0] lut [7:0];
initial begin
    lut[0] = 2'b00; // a=0, b=0, cin=0 => sum=0, cout=0
    lut[1] = 2'b01; // a=0, b=0, cin=1 => sum=1, cout=0
    lut[2] = 2'b01; // a=0, b=1, cin=0 => sum=1, cout=0
    lut[3] = 2'b10; // a=0, b=1, cin=1 => sum=0, cout=1
    lut[4] = 2'b01; // a=1, b=0, cin=0 => sum=1, cout=0
    lut[5] = 2'b10; // a=1, b=0, cin=1 => sum=0, cout=1
    lut[6] = 2'b10; // a=1, b=1, cin=0 => sum=0, cout=1
    lut[7] = 2'b11; // a=1, b=1, cin=1 => sum=1, cout=1
end

// Use the inputs as an address to retrieve the output from the LUT
always @(*) begin
    {cout, sum} = lut[{a, b, cin}];
end

endmodule