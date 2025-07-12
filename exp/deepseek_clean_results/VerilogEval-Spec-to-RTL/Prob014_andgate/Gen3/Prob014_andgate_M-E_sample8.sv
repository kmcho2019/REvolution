module TopModule(
    input a,
    input b,
    output out
);
    // 2-bit address formed by inputs
    wire [1:0] addr = {a, b};
    
    // 4x1 ROM implementing AND truth table
    reg [0:0] rom [0:3];
    
    initial begin
        rom[0] = 1'b0; // 00
        rom[1] = 1'b0; // 01
        rom[2] = 1'b0; // 10
        rom[3] = 1'b1; // 11
    end
    
    assign out = rom[addr];
endmodule