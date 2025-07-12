module edge_detect(
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg [1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {a, shift_reg[1]};
    end
end

assign rise = (shift_reg[0] == 1'b1) && (shift_reg[1] == 1'b0);
assign down = (shift_reg[0] == 1'b0) && (shift_reg[1] == 1'b1);

endmodule