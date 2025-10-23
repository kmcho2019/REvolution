module TopModule(
    input  [2:0] in,
    output [1:0] out
);

assign out = (in[0] + in[1] + in[2]) < 2 ? {1'b0, in[0] + in[1] + in[2]} : 
             (in[0] + in[1] + in[2]) == 2 ? 2'b10 : 
             (in[0] + in[1] + in[2]) == 3 ? 2'b11 : 2'b00;

endmodule