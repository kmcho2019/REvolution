module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [5:0] reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg <= 0;
    end else if (reg[5:4] == 2'b11) begin
        reg <= {2'b00, d};
    end else begin
        reg <= {reg[5:4] + 1, reg[3:0]};
    end
end

assign valid_out = (reg[5:4] == 2'b00) ? 1 : 0;
assign dout = reg[3];

endmodule