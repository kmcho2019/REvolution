module TopModule(
    input  [3:0] x,  // Note: The problem mentioned x[4] but since Verilog is 0-indexed, 
                    //       we assume x is a 4-bit vector with x[3] being the most significant bit.
    output     f
);

assign f = (x[3] && (x[1] || x[2])) || 
           (x[0] && !x[3] && x[1] && x[2]);

endmodule