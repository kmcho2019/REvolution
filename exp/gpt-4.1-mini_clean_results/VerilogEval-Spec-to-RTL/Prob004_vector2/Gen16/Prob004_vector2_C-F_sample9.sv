module TopModule (
    input  [31:0] in,
    output reg [31:0] out
);

integer i;
always @* begin
    for (i = 0; i < 4; i = i + 1) begin
        out[(i*8) +: 8] = in[((3 - i)*8) +: 8];
    end
end

endmodule