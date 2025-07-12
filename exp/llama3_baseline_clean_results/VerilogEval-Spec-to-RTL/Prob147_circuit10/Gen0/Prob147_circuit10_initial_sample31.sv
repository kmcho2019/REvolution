module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;  // register to store the state
assign state = state_reg;  // output the state

// combinational logic to generate the next state
always @(posedge clk) begin
    if (a == 0) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_reg;
    end
end

// combinational logic to generate the output q
assign q = (b == 1 && state_reg == 0) || (b == 1 && a == 1 && state_reg == 1);

endmodule