module TopModule(
    input [2:0] in,
    output reg [1:0] out
);

always @(*) begin
    out = 2'b0;
    if (in[0] == 1'b1) out = out + 1;
    if (in[1] == 1'b1) out = out + 1;
    if (in[2] == 1'b1) out = out + 1;
end

endmodule