module TopModule (
    input x,
    input y,
    output z
);
    // Create a 2-bit address
    wire [1:0] address = {x, y};
    
    // 2-bit ROM storing the truth table
    reg [0:3] rom = 4'b0010; // Outputs for 00,01,10,11
    
    // Output is selected by the address
    assign z = rom[address];
endmodule