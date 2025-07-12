module TopModule(output out);
    // Implement a 1-bit ROM that always outputs 0
    reg [0:0] rom [0:0];
    initial rom[0] = 1'b0;
    assign out = rom[0];  // Always reads address 0 which contains 0
endmodule