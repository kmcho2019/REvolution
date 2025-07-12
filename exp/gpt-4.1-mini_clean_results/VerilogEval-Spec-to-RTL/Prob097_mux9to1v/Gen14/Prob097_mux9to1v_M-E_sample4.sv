module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Concatenate all inputs into a single 144-bit bus (9 x 16 bits)
    wire [143:0] concatenated_inputs = {a, b, c, d, e, f, g, h, i};

    // For sel values 0 to 8, select the corresponding 16-bit slice
    // For sel >=9, output 16'hFFFF
    // Since inputs are packed with 'a' as the most significant bits,
    // calculate offset as (8 - sel)*16 to extract the correct slice.

    assign out = (sel < 4'd9) 
                 ? concatenated_inputs[ (8 - sel)*16 +: 16 ] 
                 : 16'hFFFF;

endmodule