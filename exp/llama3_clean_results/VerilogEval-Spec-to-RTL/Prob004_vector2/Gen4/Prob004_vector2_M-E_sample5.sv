module TopModule(
    input [31:0] in,
    output [31:0] out
);

reg [31:0] temp;

always @(*) begin
    temp = in;
    out = {temp[7:0], temp[15:8], temp[23:16], temp[31:24]};
end

endmodule