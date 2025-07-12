module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Single-stage right rotation based on control bits
assign out = {in, in} >> ctrl;

endmodule