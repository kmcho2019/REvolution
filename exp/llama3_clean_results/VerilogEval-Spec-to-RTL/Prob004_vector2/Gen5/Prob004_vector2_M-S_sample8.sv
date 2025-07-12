module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    assign out = {in[23:0], in[31:24]};

    // Alternatively, the following also works but it might not be as efficient:
    // assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

    // But the most simplified and efficient way is actually using the following:
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

    // Or even more simplified and efficient:
    assign out = {in[ 7: 0], in[15: 8], in[23:16], in[31:24]};

    // The most simplified and efficient code to reverse the bytes is actually 
    assign out = {in[ 7: 0], in[15: 8], in[23:16], in[31:24]};

endmodule