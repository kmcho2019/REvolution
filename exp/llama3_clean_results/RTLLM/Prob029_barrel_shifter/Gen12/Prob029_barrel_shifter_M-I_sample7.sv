// Improved 8-bit Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Calculate the total shift amount
    wire [2:0] shift_amount = ctrl;

    // Use Verilog's built-in shift operator to perform the rotation
    assign out = (in << shift_amount) | (in >> (8 - shift_amount));

endmodule