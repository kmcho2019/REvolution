module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // register to hold the current state
assign state = state_reg;

// combinational logic to determine the next state
always @(posedge clk) begin
    if (a) begin
        state_reg <= 1;
    end else if (state_reg && ~b) begin
        state_reg <= 1;
    end else if (~state_reg && b) begin
        state_reg <= 1;
    end else begin
        state_reg <= 0;
    end
end

// combinational logic to determine the output q
assign q = b || state_reg;

endmodule