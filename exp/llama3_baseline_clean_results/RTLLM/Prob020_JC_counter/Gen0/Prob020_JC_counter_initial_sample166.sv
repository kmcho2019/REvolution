module JC_counter(
    input  clk,
    input  rst_n,
    output [63:0] Q
);

reg [63:0] Q_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q_reg <= 64'd0;
    end else begin
        if (Q_reg[0] == 1'b0) begin
            Q_reg <= {1'b1, Q_reg[63:1]};
        end else begin
            Q_reg <= {1'b0, Q_reg[63:1]};
        end
    end
end

assign Q = Q_reg;

endmodule