module TopModule(
    input  [2:0] in,
    output reg [1:0] out
);

always @(*) begin
    out = 0;
    out += in[0];
    out += in[1];
    out += in[2];
end

endmodule