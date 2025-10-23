module TopModule (
    input  wire [5:0] y,
    input  wire       w,
    output wire       Y1,
    output wire       Y3
);

    // Mask for states leading to D: B(y[1]), C(y[2]), E(y[4]), F(y[5])
    wire mask_D_states = |(y & 6'b0110010); // bits 5,4,2,1 set: 0b0110010

    assign Y1 = y[0] & w;                // From A to B with w=1
    assign Y3 = (~w) & mask_D_states;   // From B,C,E,F to D with w=0

endmodule