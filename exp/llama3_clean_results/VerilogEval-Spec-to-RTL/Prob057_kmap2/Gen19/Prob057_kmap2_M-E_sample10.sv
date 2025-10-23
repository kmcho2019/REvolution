module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

reg [1:0] ab;
reg [1:0] cd;
reg [3:0] index;
reg out_reg;

always @(a, b, c, d) begin
    ab = {a, b};
    cd = {c, d};
    case ({cd, ab})
        4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1011, 4'b1101: out_reg = 1'b1;
        default: out_reg = 1'b0;
    endcase
end

assign out = out_reg;

endmodule