module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is don't-care, it's included for completeness
    output out
);

// Define the lookup table
reg [2**3-1:0] lut;

// Initialize the lookup table
initial begin
    lut[0] = 0; // a=0, b=0, c=0
    lut[1] = 0; // a=0, b=0, c=1
    lut[2] = 1; // a=0, b=1, c=0
    lut[3] = 1; // a=0, b=1, c=1
    lut[4] = 1; // a=1, b=0, c=0
    lut[5] = 1; // a=1, b=0, c=1
    lut[6] = 1; // a=1, b=1, c=0
    lut[7] = 1; // a=1, b=1, c=1
end

// Access the lookup table based on the input combinations
assign out = lut[{a, b, c}];

endmodule