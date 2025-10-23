module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Concatenate all output values into a single vector
    // Each 16-bit segment corresponds to a value of 'a' from 0 to 7
    wire [127:0] lut = {16'h2f19,16'hc526,16'h64ce,16'h2066,16'h5a0e,16'h27d4,16'haee0,16'h1232};

    // Select the 16-bit output by shifting and slicing
    assign q = lut >> (a * 16);

endmodule