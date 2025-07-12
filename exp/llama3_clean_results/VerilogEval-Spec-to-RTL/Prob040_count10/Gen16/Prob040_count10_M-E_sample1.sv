module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0001;
    end else if (shift_reg == 4'b1000) begin
        shift_reg <= 4'b0001;
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b1};
    end
end

assign q = shift_reg;

endmodule