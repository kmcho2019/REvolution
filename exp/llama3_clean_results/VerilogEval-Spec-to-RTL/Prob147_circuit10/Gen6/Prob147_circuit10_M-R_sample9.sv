module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
initial state_reg = 0;  // Initialize state_reg to 0

always @(posedge clk) begin
    if (~a & b) begin
        state_reg <= 1'b1;
    end else if (a & b) begin
        state_reg <= 1'b0;
    end
end

assign state = state_reg;
assign q = (~a) ? b : state_reg;

endmodule