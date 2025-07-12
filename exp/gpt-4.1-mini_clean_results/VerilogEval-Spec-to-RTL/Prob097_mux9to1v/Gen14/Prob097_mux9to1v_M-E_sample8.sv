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

    // Concatenate all inputs into a single 144-bit vector
    wire [143:0] concat_inputs = {a, b, c, d, e, f, g, h, i};

    // Calculate shift amount for selection (each input is 16 bits)
    wire [7:0] shift_amount = sel * 16;

    // Extract the selected 16 bits if sel <= 8, else output all ones
    assign out = (sel <= 4'd8) ?
                 (concat_inputs >> shift_amount)[15:0] :
                 16'hFFFF;

endmodule