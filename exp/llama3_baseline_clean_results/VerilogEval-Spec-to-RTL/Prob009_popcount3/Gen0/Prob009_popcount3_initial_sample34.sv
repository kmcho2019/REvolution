module TopModule(
    input  [2:0] in,  // 3-bit input
    output reg [1:0] out  // 2-bit output
);

    always @(*) begin
        out = 2'b0;
        if (in[0]) out = out + 1'b1;
        if (in[1]) out = out + 1'b1;
        if (in[2]) out = out + 1'b1;
    end

endmodule