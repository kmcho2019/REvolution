module BitSliceRegister(
    input         clk,
    input         resetn,
    input         byteena,
    input         d,
    output        q
);

reg q_reg;

always @(posedge clk) begin
    if (~resetn) begin
        q_reg <= 1'd0;
    end else if (byteena) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin: bit_slice_gen
        wire byteena_i;
        assign byteena_i = (i >= 8) ? byteena[1] : byteena[0];
        BitSliceRegister u_bit_slice(
            .clk(clk),
            .resetn(resetn),
            .byteena(byteena_i),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule