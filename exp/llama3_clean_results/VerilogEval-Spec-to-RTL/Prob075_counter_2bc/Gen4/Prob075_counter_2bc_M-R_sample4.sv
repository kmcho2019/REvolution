module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
wire increment, decrement;

assign increment = train_valid && train_taken;
assign decrement = train_valid && !train_taken;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else if (increment) begin
        state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1;
    end else if (decrement) begin
        state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1;
    end
end

assign state = state_reg;

endmodule