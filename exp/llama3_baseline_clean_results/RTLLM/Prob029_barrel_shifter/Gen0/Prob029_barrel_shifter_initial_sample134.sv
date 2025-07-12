// 2-to-1 Multiplexer submodule
module mux2X1(
    input   [7:0] in0,  // First input
    input   [7:0] in1,  // Second input
    input         sel, // Select signal
    output  [7:0] out  // Output
);
    assign out = (sel == 1'b1) ? in1 : in0;
endmodule

// Barrel Shifter module
module barrel_shifter(
    input   [7:0] in,   // 8-bit input to be shifted
    input   [2:0] ctrl, // 3-bit control signal
    output  [7:0] out  // 8-bit shifted output
);

    // Intermediate wires for shifted inputs
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign shift4 = (ctrl[2] == 1'b1) ? {in[3:0], 4'b0000} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    assign shift2 = (ctrl[1] == 1'b1) ? {shift4[5:0], 2'b00} : shift4;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign shift1 = (ctrl[0] == 1'b1) ? {shift2[6:0], 1'b0} : shift2;

    // Output is the final shifted result
    assign out = shift1;

endmodule