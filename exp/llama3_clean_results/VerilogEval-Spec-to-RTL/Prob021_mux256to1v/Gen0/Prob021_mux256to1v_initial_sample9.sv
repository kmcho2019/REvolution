module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);
    
    // Calculate the bit offset based on the select signal
    wire [9:0] offset = sel * 4;
    
    // Use the offset to extract the corresponding 4-bit value from the input vector
    assign out = in[offset + 3 : offset];
    
endmodule