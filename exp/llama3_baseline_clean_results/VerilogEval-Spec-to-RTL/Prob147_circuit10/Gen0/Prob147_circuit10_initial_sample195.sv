module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @ (posedge clk) begin
    if (a && b) begin
        state_reg <= 0;
    end else if (!a && !b && state_reg == 0) begin
        state_reg <= 1;
    end else if (!a && b && state_reg == 0) begin
        state_reg <= 0;
    end else if (a && !b && state_reg == 1) begin
        state_reg <= 1;
    end else if (!a && !b && state_reg == 1) begin
        state_reg <= 1;
    end else if (a && b && state_reg == 1) begin
        state_reg <= 0;
    end else if (!a && b && state_reg == 1) begin
        state_reg <= 1;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = b;

endmodule