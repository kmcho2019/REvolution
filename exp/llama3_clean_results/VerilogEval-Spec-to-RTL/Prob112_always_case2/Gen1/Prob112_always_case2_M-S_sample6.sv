module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit output for position
);

    assign pos = (in[3]) ? 2'b11 : 
                 (in[2]) ? 2'b10 : 
                 (in[1]) ? 2'b01 : 
                 (in[0]) ? 2'b00 : 2'b00;

endmodule