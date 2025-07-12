module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

reg [1:0] ab;
reg [1:0] cd;

assign ab = {a, b};
assign cd = {c, d};

always @(*) begin
    if ((cd == 2'b00 && (ab == 2'b01 || ab == 2'b10)) ||
        (cd == 2'b01 && (ab == 2'b00 || ab == 2'b11)) ||
        (cd == 2'b11 && (ab == 2'b01 || ab == 2'b10))) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule