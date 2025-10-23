module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    reg [99:0] temp;

    always @(*) begin
        temp = {in[3:0], in[7:4], in[11:8], in[15:12], in[19:16], in[23:20], in[27:24], in[31:28],
                 in[35:32], in[39:36], in[43:40], in[47:44], in[51:48], in[55:52], in[59:56], in[63:60],
                 in[67:64], in[71:68], in[75:72], in[79:76], in[83:80], in[87:84], in[91:88], in[95:92], in[99:96]};
        out = temp;
    end

endmodule