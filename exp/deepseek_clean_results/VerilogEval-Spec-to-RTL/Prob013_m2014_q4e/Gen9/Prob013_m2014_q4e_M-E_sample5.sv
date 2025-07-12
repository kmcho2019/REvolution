module TopModule (
    input  in1,
    input  in2,
    output out
);
    // 2-input NOR implemented as 4x1 ROM
    reg [0:3] nor_rom;
    
    initial begin
        // Initialize ROM with NOR truth table
        nor_rom[0] = 1'b1;  // 00 -> 1
        nor_rom[1] = 1'b0;  // 01 -> 0
        nor_rom[2] = 1'b0;  // 10 -> 0
        nor_rom[3] = 1'b0;  // 11 -> 0
    end
    
    assign out = nor_rom[{in1, in2}];
endmodule