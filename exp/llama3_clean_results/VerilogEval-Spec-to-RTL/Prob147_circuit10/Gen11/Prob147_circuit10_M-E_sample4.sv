module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    case ({a, b})
        2'b00: state_reg <= state_reg;
        2'b01: state_reg <= ~state_reg;
        2'b10: state_reg <= state_reg;
        2'b11: state_reg <= ~state_reg;
    endcase
end

assign q = (state_reg == 0 && b == 1) || (state_reg == 1 && b == 0);

endmodule