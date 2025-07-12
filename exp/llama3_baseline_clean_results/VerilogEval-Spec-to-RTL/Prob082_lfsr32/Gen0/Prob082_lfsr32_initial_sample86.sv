module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @ (posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= {q[30:0], q[31] ^ q[21] ^ q[1] ^ q[0]};
    end
end

assign q = q_reg;

endmodule