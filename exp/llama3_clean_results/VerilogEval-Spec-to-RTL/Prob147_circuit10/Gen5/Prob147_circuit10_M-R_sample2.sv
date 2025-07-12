module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // flip-flop
assign state = state_reg; // observable output

always @(posedge clk) begin
    case ({a, b})
        2'b01: state_reg <= 1'b1; // transition to S1 when a=0, b=1
        2'b00: state_reg <= state_reg; // remain in S1 if already in S1, else remain in S0
        default: state_reg <= 1'b0; // default to S0 for other cases
    endcase
end

// Combinational logic to generate output q
assign q = (b || (state_reg && a));

endmodule