module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    reg [7:0] lut [1:0]; // Lookup table to store inputs a and b

    always @(*) begin
        // Initialize the LUT with inputs a and b
        lut[0] = a;
        lut[1] = b;
        
        // Use the sel signal as an address to select the output
        out = lut[sel];
    end

endmodule