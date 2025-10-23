module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit position (sel*4)
    wire [9:0] shift_amount = {sel, 2'b00}; // Multiply sel by 4 (equivalent to left shift by 2)

    // Right shift the input to align the selected bits to LSBs
    wire [1023:0] shifted = in >> shift_amount;

    // Output the 4 LSBs
    assign out = shifted[3:0];

endmodule