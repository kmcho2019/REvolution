module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Define the truth table as a lookup table
    reg [15:0] lut = 16'b0000000000001110;  // Truth table for (a&b)|(c&d)
    
    // Use input concatenation as LUT address
    wire [3:0] address = {a, b, c, d};
    
    // Output the LUT result
    assign out = lut[address];
    assign out_n = ~out;
endmodule