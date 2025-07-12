module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], d[7]};
    q <= shift_reg;
end

endmodule