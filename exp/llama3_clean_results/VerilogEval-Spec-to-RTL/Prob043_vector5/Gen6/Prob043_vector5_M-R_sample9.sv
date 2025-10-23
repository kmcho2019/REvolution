module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Directly calculate each bit of the out vector
assign out[24] = (signals[0] == signals[0]);
assign out[23] = (signals[0] == signals[1]);
assign out[22] = (signals[0] == signals[2]);
assign out[21] = (signals[0] == signals[3]);
assign out[20] = (signals[0] == signals[4]);
assign out[19] = (signals[1] == signals[0]);
assign out[18] = (signals[1] == signals[1]);
assign out[17] = (signals[1] == signals[2]);
assign out[16] = (signals[1] == signals[3]);
assign out[15] = (signals[1] == signals[4]);
assign out[14] = (signals[2] == signals[0]);
assign out[13] = (signals[2] == signals[1]);
assign out[12] = (signals[2] == signals[2]);
assign out[11] = (signals[2] == signals[3]);
assign out[10] = (signals[2] == signals[4]);
assign out[9]  = (signals[3] == signals[0]);
assign out[8]  = (signals[3] == signals[1]);
assign out[7]  = (signals[3] == signals[2]);
assign out[6]  = (signals[3] == signals[3]);
assign out[5]  = (signals[3] == signals[4]);
assign out[4]  = (signals[4] == signals[0]);
assign out[3]  = (signals[4] == signals[1]);
assign out[2]  = (signals[4] == signals[2]);
assign out[1]  = (signals[4] == signals[3]);
assign out[0]  = (signals[4] == signals[4]);

endmodule