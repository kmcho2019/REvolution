module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Sum the bits directly using Verilog integer addition, then truncate to 2 bits
    assign out = (in[0] + in[1] + in[2]);

endmodule