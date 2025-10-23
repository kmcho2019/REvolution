module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;  // internal register to store the state
assign state = state_reg;

// Combinational logic to determine the next state
always @(*) begin
    if (a == 1'b0 && b == 1'b1) begin
        state_reg = 1'b1;
    end else if (a == 1'b1 && b == 1'b1) begin
        state_reg = 1'b0;
    end else begin
        state_reg = state_reg;  // self-loop
    end
end

// Combinational logic to determine the output q
assign q = (a == 1'b1 && b == 1'b0) || (state_reg == 1'b1 && b == 1'b1);

// D flip-flop to store the state
always @(posedge clk) begin
    state_reg <= state_reg;  // update state_reg on the positive edge of the clock
end

initial begin
    state_reg = 1'b0;  // initialize state_reg to 0
end

endmodule