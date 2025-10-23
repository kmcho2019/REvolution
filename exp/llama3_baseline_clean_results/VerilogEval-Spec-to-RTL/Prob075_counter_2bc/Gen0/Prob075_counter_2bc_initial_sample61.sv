module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else if (train_valid) begin
        if (train_taken && state_reg < 2'd3) begin
            state_reg <= state_reg + 1'b1;
        end else if (!train_taken && state_reg > 2'd0) begin
            state_reg <= state_reg - 1'b1;
        end
    end
end

assign state = state_reg;

endmodule