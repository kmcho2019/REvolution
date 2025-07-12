module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

// State transition logic - toggle only when both inputs are high
wire next_state = (a & b) ? ~state : state;

// State register
reg state_reg = 0;
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic - mux between b and ~(a&b) based on state
assign q = state_reg ? ~(a & b) : b;
assign state = state_reg;

endmodule