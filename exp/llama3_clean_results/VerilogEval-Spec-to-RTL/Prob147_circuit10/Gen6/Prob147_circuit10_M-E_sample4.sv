module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

reg state_reg;
initial state_reg = 0;

assign state = state_reg;

always @(posedge clk) begin
    if (!a && b) begin
        state_reg <= 1;
    end else if (a && b) begin
        state_reg <= 0;
    end else if (!a && !b && state_reg) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_reg;
    end
end

always @(a, b, state_reg) begin
    if (a) begin
        q <= state_reg;
    end else begin
        q <= b;
    end
end

endmodule