module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the base address using hierarchical selection:
    // Upper 4 bits select the group (0-15), lower 4 bits select within group (0-15)
    // Each group has 16 entries (64 bits), each entry is 4 bits
    wire [10:0] base_addr = {sel[7:4], 6'b0} + {sel[3:0], 2'b0};
    
    // Directly select the 4-bit output
    assign out = in[base_addr +: 4];
endmodule