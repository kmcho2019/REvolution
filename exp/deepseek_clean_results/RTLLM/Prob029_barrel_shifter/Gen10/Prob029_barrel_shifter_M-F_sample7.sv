module barrel_shifter(
    input [7:0] in,        // Input data to be rotated
    input [2:0] ctrl,      // Control bits: [2]=4-bit, [1]=2-bit, [0]=1-bit right rotation
    output [7:0] out       // Rotated output
);

    // Stage 1: Right rotate by 4 positions when ctrl[2] is set
    wire [7:0] rot4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: Right rotate by 2 positions when ctrl[1] is set (operates on rot4 result)
    wire [7:0] rot2 = ctrl[1] ? {rot4[1:0], rot4[7:2]} : rot4;
    
    // Stage 3: Right rotate by 1 position when ctrl[0] is set (operates on rot2 result)
    assign out = ctrl[0] ? {rot2[0], rot2[7:1]} : rot2;

    /* Rotation Examples:
       ctrl=3'b000: No rotation (out = in)
       ctrl=3'b001: Right rotate by 1
       ctrl=3'b010: Right rotate by 2
       ctrl=3'b100: Right rotate by 4
       ctrl=3'b111: Right rotate by 7 (4+2+1)
    */
endmodule