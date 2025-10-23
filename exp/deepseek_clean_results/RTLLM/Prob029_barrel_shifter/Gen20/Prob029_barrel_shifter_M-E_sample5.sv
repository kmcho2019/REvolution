module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Pre-compute all possible rotated versions
    wire [7:0] rot[0:7];
    
    // Generate all rotation amounts (0-7)
    assign rot[0] = in;  // No rotation
    assign rot[1] = {in[0], in[7:1]};  // Rotate right 1
    assign rot[2] = {in[1:0], in[7:2]}; // Rotate right 2
    assign rot[3] = {in[2:0], in[7:3]}; // Rotate right 3
    assign rot[4] = {in[3:0], in[7:4]}; // Rotate right 4
    assign rot[5] = {in[4:0], in[7:5]}; // Rotate right 5
    assign rot[6] = {in[5:0], in[7:6]}; // Rotate right 6
    assign rot[7] = {in[6:0], in[7]};   // Rotate right 7

    // Calculate effective shift amount (sum of active control bits)
    wire [2:0] shift_amount;
    assign shift_amount = ctrl[0] + ctrl[1] + ctrl[2];

    // Final output selection based on computed shift amount
    assign out = rot[shift_amount];

endmodule