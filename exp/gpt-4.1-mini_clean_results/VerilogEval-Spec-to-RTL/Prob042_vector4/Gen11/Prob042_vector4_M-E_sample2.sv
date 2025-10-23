module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Use conditional operator to assign upper 24 bits based on sign bit
    assign out = (in[7] == 1'b1) ? {24'hFFFFFF, in} : {24'h000000, in};
endmodule