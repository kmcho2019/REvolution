module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Stage 1: 4-bit right rotation
wire [7:0] shift4 = ctrl[2] ? {in[3:0], in[7:4]} : in;

// Stage 2: 2-bit right rotation
wire [7:0] shift2 = ctrl[1] ? {shift4[1:0], shift4[7:2]} : shift4;

// Stage 3: 1-bit right rotation
assign out = ctrl[0] ? {shift2[0], shift2[7:1]} : shift2;

endmodule