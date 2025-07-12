module TopModule(output zero);
    reg [0:0] rom [0:1];  // 1-bit wide, 2-entry ROM
    
    initial begin
        rom[0] = 0;  // Initialize ROM entries
        rom[1] = 0;
    end
    
    assign zero = rom[0];  // Always output the first ROM entry (0)
endmodule