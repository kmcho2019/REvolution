module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Concatenate inputs to form address
    wire [2:0] addr = {a, b, cin};

    // LUT for sum and carry-out
    reg [1:0] lut [0:7];
    
    // Initialize LUT with full adder truth table
    initial begin
        lut[0] = 2'b00; // 0+0+0 = 00
        lut[1] = 2'b01; // 0+0+1 = 01
        lut[2] = 2'b01; // 0+1+0 = 01
        lut[3] = 2'b10; // 0+1+1 = 10
        lut[4] = 2'b01; // 1+0+0 = 01
        lut[5] = 2'b10; // 1+0+1 = 10
        lut[6] = 2'b10; // 1+1+0 = 10
        lut[7] = 2'b11; // 1+1+1 = 11
    end

    // Output assignment
    assign {cout, sum} = lut[addr];

endmodule