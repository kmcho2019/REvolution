module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    state_reg <= a;  // Simply store the previous value of 'a'
end

assign q = b ^ state_reg;  // XOR current 'b' with stored 'a'
assign state = state_reg;

endmodule