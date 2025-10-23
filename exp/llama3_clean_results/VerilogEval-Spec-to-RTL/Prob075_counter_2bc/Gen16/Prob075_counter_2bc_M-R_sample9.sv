module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else if (train_valid) begin
        if (train_taken && state_reg < 2'b11) begin
            state_reg <= state_reg + 1'b1; // Increment
        end else if (!train_taken && state_reg > 2'b00) begin
            state_reg <= state_reg - 1'b1; // Decrement
        end
    end
end

endmodule