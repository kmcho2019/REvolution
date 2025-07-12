module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Combine control bits to get total shift amount (0-7)
    wire [2:0] shift = ctrl;
    
    // Perform right rotation in one step
    assign out = {in, in} >> shift;
endmodule