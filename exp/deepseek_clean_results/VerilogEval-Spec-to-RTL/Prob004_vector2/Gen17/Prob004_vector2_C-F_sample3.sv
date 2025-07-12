module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Optimal direct concatenation for 32-bit byte reversal
    // Combines best PPA of Example 2 with clean interface of Example 1
    assign out = {in[7:0],   in[15:8],
                  in[23:16], in[31:24]};
endmodule