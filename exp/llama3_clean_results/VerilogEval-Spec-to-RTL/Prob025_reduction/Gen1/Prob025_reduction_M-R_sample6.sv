module TopModule(
    input [7:0] in,
    output parity
);

reg parity_reg;
assign parity = parity_reg;

always @(*) begin
    parity_reg = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_reg = parity_reg ^ in[i];
    end
end

endmodule