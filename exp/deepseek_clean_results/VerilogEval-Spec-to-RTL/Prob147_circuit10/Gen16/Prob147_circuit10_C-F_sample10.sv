module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    case ({a,b})
        2'b11: state_reg <= 1'b1;
        2'b00: state_reg <= 1'b0;
        default: state_reg <= state_reg;
    endcase
end

assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule