module TopModule (
    input  [31:0] in,
    input        en,    // New enable signal
    output [31:0] out
);
    assign out = en ? {in[7:0], in[15:8], in[23:16], in[31:24]} : 32'b0;
endmodule