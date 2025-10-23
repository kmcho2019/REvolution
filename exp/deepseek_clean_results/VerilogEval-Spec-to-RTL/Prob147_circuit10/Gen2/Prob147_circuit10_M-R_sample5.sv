module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

// State transition logic
wire state_next = (a ^ b) ? ~state_reg : state_reg;

// Output logic
assign q = (state_reg & (a | b)) | (~state_reg & a & b);

always @(posedge clk) begin
    state_reg <= state_next;
end

assign state = state_reg;

endmodule