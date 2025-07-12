module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the starting bit position directly from sel
    // (sel[7:4]*64) selects the group, (sel[3:0]*4) selects within group
    wire [10:0] bit_pos = {sel[7:4], 6'b0} + {sel[3:0], 2'b0};
    
    // Directly select the 4-bit output
    assign out = in[bit_pos +: 4];
endmodule