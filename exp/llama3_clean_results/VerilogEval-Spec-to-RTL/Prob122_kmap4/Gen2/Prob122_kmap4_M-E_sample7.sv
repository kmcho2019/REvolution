module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

reg [15:0] lut;

initial begin
    lut = 16'h0101_0101; // Define the LUT based on the Karnaugh map
end

assign out = lut[{a, b, c, d}]; // Use the LUT to determine the output

endmodule