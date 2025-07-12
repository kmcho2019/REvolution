module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] counter_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter_reg = 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        if (train_taken) begin
            counter_reg = (counter_reg == 2'b11) ? counter_reg : counter_reg + 1'b1; // Increment with saturation
        end else begin
            counter_reg = (counter_reg == 2'b00) ? counter_reg : counter_reg - 1'b1; // Decrement with saturation
        end
    end
end

assign state = counter_reg;

endmodule