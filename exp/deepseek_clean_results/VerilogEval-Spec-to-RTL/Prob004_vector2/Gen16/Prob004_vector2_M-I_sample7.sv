module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Optimal byte reversal - can't be improved further at RTL level
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
endmodule