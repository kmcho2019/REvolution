module TopModule(
    input  [7:0] in,
    output [7:0] out
);

reg [7:0] temp;

always @(in) begin
    temp[0] = in[7];
    temp[1] = in[6];
    temp[2] = in[5];
    temp[3] = in[4];
    temp[4] = in[3];
    temp[5] = in[2];
    temp[6] = in[1];
    temp[7] = in[0];
    out <= temp;
end

endmodule