module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] shift4, shift2;
    
    // First stage: shift by 4 if ctrl[2] is set
    assign shift4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Second stage: shift by 2 if ctrl[1] is set
    assign shift2 = ctrl[1] ? {shift4[1:0], shift4[7:2]} : shift4;
    
    // Third stage: shift by 1 if ctrl[0] is set
    assign out = ctrl[0] ? {shift2[0], shift2[7:1]} : shift2;
    
endmodule