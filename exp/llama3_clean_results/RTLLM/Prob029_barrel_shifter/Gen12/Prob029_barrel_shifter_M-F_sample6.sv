// Corrected 8-bit Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Directly calculate the shifted output based on the control signal
    assign out = {in[(7 - ctrl):0], in[7:(8 - ctrl)]};

endmodule