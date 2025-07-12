module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;  // internal register to store the state
assign state = state_reg;

always @(posedge clk) begin
    case ({a, b})
        2'b01: state_reg <= 1'b1;  // a=0, b=1: state transitions from 0 to 1
        2'b11: state_reg <= 1'b0;  // a=1, b=1: state transitions from 1 to 0
        default: state_reg <= state_reg;  // In all other cases, state remains the same
    endcase
end

assign q = (state_reg == 1'b1 && b == 1'b1) || (a == 1'b1 && b == 1'b0);

endmodule