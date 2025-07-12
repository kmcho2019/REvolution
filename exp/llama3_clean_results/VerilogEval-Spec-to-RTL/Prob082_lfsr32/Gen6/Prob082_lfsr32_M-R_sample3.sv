module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg;

wire feedback = q_reg[0] ^ q_reg[21] ^ q_reg[1];

assign q = q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg[31] <= feedback;
        for (int i = 30; i >= 1; i--) begin
            if (i == 21 || i == 1) begin
                q_reg[i] <= q_reg[i-1] ^ q_reg[0];
            end else begin
                q_reg[i] <= q_reg[i-1];
            end
        end
        q_reg[0] <= q_reg[31] ^ q_reg[0];
    end
end

endmodule