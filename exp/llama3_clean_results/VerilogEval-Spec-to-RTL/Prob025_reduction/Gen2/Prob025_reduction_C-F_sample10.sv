module TopModule(
    input [7:0] in,
    output parity
);

reg parity_reg;
assign parity = parity_reg;

always @(*) begin
    parity_reg = ^in;
end

endmodule