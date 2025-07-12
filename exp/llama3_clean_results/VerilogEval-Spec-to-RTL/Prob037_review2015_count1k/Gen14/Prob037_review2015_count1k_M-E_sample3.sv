module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'd0;
    end else begin
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

assign q = shift_reg;

endmodule