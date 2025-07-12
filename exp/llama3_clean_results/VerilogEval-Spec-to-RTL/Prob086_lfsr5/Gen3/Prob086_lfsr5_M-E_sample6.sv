module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b10000; // reset to a non-zero state
    end else begin
        reg tap_xor = q_reg[0] ^ q_reg[2] ^ q_reg[3];
        q_reg <= {tap_xor, q_reg[4:1]};
    end
end

assign q = q_reg;

endmodule